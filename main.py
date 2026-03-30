import backend
import sys


def launch_gui():
    import tkinter as tk
    import interface

    root = tk.Tk()
    app = interface.BlockchainApp(root)
    root.mainloop()

# ---------------- DATABASE CONNECTION ----------------
def connect_db():
    return backend.connect_db()

# ---------------- LOGIN ----------------
def login():
    conn = connect_db()
    cursor = conn.cursor()

    try:
        user_id = int(input("Enter User ID: "))
    except ValueError:
        print("Invalid input")
        return None

    cursor.execute("SELECT user_id FROM users WHERE user_id = %s", (user_id,))
    user = cursor.fetchone()

    if user:
        print("Login successful")

        cursor.execute("""
        INSERT INTO audit_log (user_id, action, target_table, target_id)
        VALUES (%s, 'LOGIN_SUCCESS', 'users', %s)
        """, (user_id, user_id))

        conn.commit()
        print(f"[AUDIT] LOGIN_SUCCESS recorded for user {user_id}")
        conn.close()
        return user_id
    else:
        print("Login failed")

        cursor.execute("""
        INSERT INTO audit_log (user_id, action, target_table, target_id)
        VALUES (NULL, 'LOGIN_FAILED', 'users', NULL)
        """)

        conn.commit()
        print("[AUDIT] LOGIN_FAILED recorded")
        conn.close()
        return None

# ---------------- ADD TRANSACTION ----------------
def add_transaction(user_id):
    conn = connect_db()

    choice = input("Use latest block? (y/n): ").lower()

    if choice == "y":
        block_id = backend.get_latest_block(conn)
        if not block_id:
            print("No blocks found")
            conn.close()
            return
    else:
        try:
            block_id = int(input("Enter block ID: "))
        except ValueError:
            print("Invalid block ID")
            return

    print("Using block ID:", block_id)

    # INPUT DATA
    drug = input("Enter drug name: ")
    dosage = input("Enter dosage: ")
    try:
        result = backend.add_transaction(conn, user_id, block_id, drug, dosage, quantity=None)
        print("Transaction successfully added")
        print("Block", result["block_id"], "has", result["count"], "transactions")
        if result["sealed"]:
            print("Block sealed automatically")
    except ValueError as e:
        print(str(e))
    finally:
        conn.close()

# ---------------- VIEW BLOCKS ----------------
def view_blocks():
    conn = connect_db()
    try:
        for row in backend.get_blocks(conn):
            print(row)
    finally:
        conn.close()

# ---------------- VIEW TRANSACTIONS ----------------
def view_transactions():
    conn = connect_db()
    try:
        for row in backend.get_transactions(conn, limit=100):
            print(row)
    finally:
        conn.close()

# ---------------- VALIDATE ----------------
def validate_blockchain():
    conn = connect_db()
    try:
        for row in backend.validate_blockchain(conn):
            print(row)
    finally:
        conn.close()

# ---------------- REPAIR ----------------
def repair_blockchain(user_id):
    conn = connect_db()
    try:
        backend.repair_blockchain(conn, user_id=user_id)
        print("Blockchain repaired")
    finally:
        conn.close()

# ---------------- REBUILD HASHES ----------------
def rebuild_hashes(user_id):
    conn = connect_db()
    try:
        backend.repair_blockchain(conn, user_id=user_id, audit_action="REBUILD_HASHES")
        print("Hashes rebuilt (including transaction data)")
    finally:
        conn.close()

# ---------------- MENU ----------------
def menu(user_id):
    while True:
        print("\nBlockchain System")
        print("1 Add Transaction")
        print("2 View Blocks")
        print("3 View Transactions")
        print("4 Validate Blockchain")
        print("5 Rebuild Hashes (include tx data)")
        print("6 Repair Blockchain")
        print("7 Exit")

        choice = input("Enter choice: ")

        if choice == "1":
            add_transaction(user_id)
        elif choice == "2":
            view_blocks()
        elif choice == "3":
            view_transactions()
        elif choice == "4":
            validate_blockchain()
        elif choice == "5":
            rebuild_hashes(user_id)
        elif choice == "6":
            repair_blockchain(user_id)
        elif choice == "7":
            break
        else:
            print("Invalid choice")

def run_cli():
    user = login()
    if user:
        menu(user)
    else:
        print("Exiting system")


# ---------------- RUN ----------------
if __name__ == "__main__":
    print("Select mode:")
    print("1 CLI")
    print("2 GUI")
    choice = input("Enter choice: ").strip()

    if choice == "2":
        launch_gui()
    elif choice == "1":
        run_cli()
    else:
        print("Invalid choice")
