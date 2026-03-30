import mysql.connector
import json


def _get_tx_hash_map(conn):
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT 
            block_id,
            SHA2(
                IFNULL(
                    GROUP_CONCAT(
                        CONCAT(transaction_id, ':', user_id, ':', transaction_data)
                        ORDER BY transaction_id SEPARATOR '|'
                    ),
                    ''
                ),
                256
            ) AS tx_hash
        FROM blockchain_transactions
        GROUP BY block_id
        """
    )
    return {row[0]: row[1] for row in cursor.fetchall()}


def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="prescription_system",
    )


def get_latest_block(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT block_id FROM blockchain_blocks ORDER BY block_id DESC LIMIT 1")
    row = cursor.fetchone()
    return row[0] if row else None


def add_transaction(conn, user_id, block_id, drug, dosage, quantity=None):
    cursor = conn.cursor()

    cursor.execute("SELECT is_sealed FROM blockchain_blocks WHERE block_id = %s", (block_id,))
    row = cursor.fetchone()
    if not row:
        raise ValueError("Block not found")

    if row[0] == 1:
        raise ValueError("Block is sealed and cannot accept new transactions")

    cursor.execute(
        """
        SELECT 
            b.block_hash = SHA2(CONCAT(b.block_id, b.previous_hash, b.created_at, IFNULL(tx.tx_hash,'')), 256)
        FROM blockchain_blocks b
        LEFT JOIN (
            SELECT 
                block_id,
                SHA2(
                    IFNULL(
                        GROUP_CONCAT(
                            CONCAT(transaction_id, ':', user_id, ':', transaction_data)
                            ORDER BY transaction_id SEPARATOR '|'
                        ),
                        ''
                    ),
                    256
                ) AS tx_hash
            FROM blockchain_transactions
            GROUP BY block_id
        ) tx ON b.block_id = tx.block_id
        WHERE b.block_id = %s
        """,
        (block_id,),
    )
    valid = cursor.fetchone()[0]
    if not valid:
        raise ValueError("Block is tampered and cannot accept transactions")

    payload = {"drug": drug, "dosage": dosage}
    if quantity not in (None, ""):
        payload["quantity"] = quantity

    data = json.dumps(payload)

    cursor.execute(
        """
        INSERT INTO blockchain_transactions
        (block_id, user_id, reference_table, reference_id, transaction_data)
        VALUES (%s, %s, 'prescriptions', 1, %s)
        """,
        (block_id, user_id, data),
    )
    conn.commit()

    cursor.execute(
        """
        INSERT INTO audit_log (user_id, action, target_table, target_id)
        VALUES (%s, 'ADD_TRANSACTION', 'blockchain_transactions', %s)
        """,
        (user_id, block_id),
    )
    conn.commit()
    print(f"[AUDIT] ADD_TRANSACTION logged for user {user_id} on block {block_id}")

    cursor.execute("SELECT COUNT(*) FROM blockchain_transactions WHERE block_id = %s", (block_id,))
    count = cursor.fetchone()[0]

    sealed = False
    if count >= 6:
        cursor.execute("UPDATE blockchain_blocks SET is_sealed = 1 WHERE block_id = %s", (block_id,))
        conn.commit()
        sealed = True

    return {"block_id": block_id, "count": count, "sealed": sealed}


def get_blocks(conn):
    cursor = conn.cursor()
    cursor.execute(
        "SELECT block_id, previous_hash, block_hash, is_sealed, created_at FROM blockchain_blocks ORDER BY block_id"
    )
    return cursor.fetchall()


def get_transactions(conn, limit=100):
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT transaction_id, block_id, user_id, transaction_data, created_at
        FROM blockchain_transactions
        ORDER BY transaction_id DESC
        LIMIT %s
        """,
        (limit,),
    )
    return cursor.fetchall()


def validate_blockchain(conn):
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT 
            b1.block_id,
            CASE 
                WHEN b1.block_hash = SHA2(CONCAT(b1.block_id, b1.previous_hash, b1.created_at, IFNULL(tx.tx_hash,'')), 256)
                THEN 'HASH OK'
                ELSE 'HASH TAMPERED'
            END as hash_status,
            CASE 
                WHEN b1.block_id = 1 THEN 'GENESIS'
                WHEN b1.previous_hash = b2.block_hash THEN 'CHAIN OK'
                ELSE 'CHAIN BROKEN'
            END as chain_status
        FROM blockchain_blocks b1
        LEFT JOIN (
            SELECT 
                block_id,
                SHA2(
                    IFNULL(
                        GROUP_CONCAT(
                            CONCAT(transaction_id, ':', user_id, ':', transaction_data)
                            ORDER BY transaction_id SEPARATOR '|'
                        ),
                        ''
                    ),
                    256
                ) AS tx_hash
            FROM blockchain_transactions
            GROUP BY block_id
        ) tx ON b1.block_id = tx.block_id
        LEFT JOIN blockchain_blocks b2 
        ON b1.block_id = b2.block_id + 1
        ORDER BY b1.block_id
        """
    )
    return cursor.fetchall()


def repair_blockchain(conn, user_id=None, audit_action="REPAIR_BLOCKCHAIN"):
    cursor = conn.cursor()
    cursor.execute("SELECT block_id, previous_hash, created_at FROM blockchain_blocks ORDER BY block_id")
    blocks = cursor.fetchall()
    tx_hash_map = _get_tx_hash_map(conn)

    previous_block_hash = None
    for block_id, prev_hash, created_at in blocks:
        # For non-genesis blocks, relink to the actual previous block hash
        if block_id != 1 and previous_block_hash is not None:
            prev_hash = previous_block_hash
            cursor.execute(
                "UPDATE blockchain_blocks SET previous_hash = %s WHERE block_id = %s",
                (prev_hash, block_id),
            )

        tx_hash = tx_hash_map.get(block_id) or ""
        cursor.execute("SELECT SHA2(CONCAT(%s,%s,%s,%s),256)", (block_id, prev_hash, created_at, tx_hash))
        new_hash = cursor.fetchone()[0]
        cursor.execute("UPDATE blockchain_blocks SET block_hash = %s WHERE block_id = %s", (new_hash, block_id))
        previous_block_hash = new_hash

    conn.commit()

    if user_id is not None:
        cursor.execute(
            """
            INSERT INTO audit_log (user_id, action, target_table, target_id)
            VALUES (%s, %s, 'blockchain_blocks', NULL)
            """,
            (user_id, audit_action),
        )
        conn.commit()
        print(f"[AUDIT] {audit_action} logged for user {user_id}")
