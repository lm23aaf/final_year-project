import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
import backend
import hashlib

class BlockchainApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Blockchain Prescription System")
        self.root.geometry("900x600")
        self.root.configure(bg="#f0f0f0")
        self.current_user = None
        self.show_login_window()

    def _audit_notice(self, message):
        print(f"[AUDIT] {message}")
        messagebox.showinfo("Audit Log", message)

    def _record_failed_login(self, conn, attempted_user_id=None, existing_user_id=None):
        cursor = conn.cursor()
        wrote_any = False

        def safe_exec(sql, params):
            nonlocal wrote_any
            try:
                cursor.execute(sql, params)
                wrote_any = True
                return True
            except Exception:
                conn.rollback()
                return False

        # audit_log
        safe_exec(
            """
            INSERT INTO audit_log (user_id, action, target_table, target_id)
            VALUES (%s, 'LOGIN_FAILED', 'users', %s)
            """,
            (existing_user_id, existing_user_id),
        )

        # security_audit_log (if table exists)
        safe_exec(
            """
            INSERT INTO security_audit_log (action_performed, performed_by, status, remarks)
            VALUES (%s, %s, %s, %s)
            """,
            ('LOGIN_FAILED', existing_user_id, 'FAILED', f'Failed login attempt with User ID: {attempted_user_id}'),
        )

        # system_notifications (if table exists)
        safe_exec(
            """
            INSERT INTO system_notifications (user_id, message, read_status)
            VALUES (%s, %s, %s)
            """,
            (None, 'Failed login attempt detected', 0),
        )

        # failed_logins (handle optional attempted_user_id column)
        try:
            cursor.execute(
                """
                SELECT COUNT(*)
                FROM information_schema.COLUMNS
                WHERE table_schema = DATABASE()
                  AND table_name = 'failed_logins'
                  AND column_name = 'attempted_user_id'
                """
            )
            has_attempted = cursor.fetchone()[0] > 0
        except Exception:
            has_attempted = False

        if has_attempted:
            safe_exec(
                """
                INSERT INTO failed_logins (user_id, attempted_user_id, ip_address)
                VALUES (%s, %s, %s)
                """,
                (existing_user_id, attempted_user_id, None),
            )
        else:
            safe_exec(
                """
                INSERT INTO failed_logins (user_id, ip_address)
                VALUES (%s, %s)
                """,
                (existing_user_id, None),
            )

        if wrote_any:
            conn.commit()
            self._audit_notice(f"LOGIN_FAILED recorded (attempted_user_id={attempted_user_id})")

    def connect_db(self):
        """Connect to the database"""
        try:
            return backend.connect_db()
        except Exception as err:
            messagebox.showerror("Database Error", f"Database connection failed: {err}")
            return None

    def clear_window(self):
        """Clear all widgets from window"""
        for widget in self.root.winfo_children():
            widget.destroy()

    # ======================== LOGIN WINDOW ========================
    def show_login_window(self):
        """Display login window"""
        self.clear_window()
        
        frame = ttk.Frame(self.root, padding="20")
        frame.pack(expand=True)

        title_label = ttk.Label(frame, text="Blockchain Prescription System", 
                                font=("Helvetica", 20, "bold"))
        title_label.pack(pady=20)

        ttk.Label(frame, text="User ID:", font=("Helvetica", 12)).pack(pady=5)
        user_id_entry = ttk.Entry(frame, width=30, font=("Helvetica", 12))
        user_id_entry.pack(pady=5)

        ttk.Label(frame, text="Password:", font=("Helvetica", 12)).pack(pady=5)
        password_entry = ttk.Entry(frame, width=30, font=("Helvetica", 12), show="*")
        password_entry.pack(pady=5)

        def login_action():
            user_id = user_id_entry.get().strip()
            password = password_entry.get().strip()

            if not user_id or not password:
                messagebox.showerror("Error", "Please enter both User ID and Password")
                return

            try:
                user_id = int(user_id)
            except ValueError:
                messagebox.showerror("Error", "User ID must be a number")
                return

            self.login(user_id, password)

        ttk.Button(frame, text="Login", command=login_action).pack(pady=20)
        ttk.Button(frame, text="Exit", command=self.root.quit).pack(pady=5)

    def login(self, user_id, password):
        """Authenticate user"""
        conn = self.connect_db()
        if not conn:
            return

        cursor = conn.cursor()
        try:
            # Check if user exists in users table
            cursor.execute("SELECT user_id, username, role, password_hash FROM users WHERE user_id = %s", (user_id,))
            user = cursor.fetchone()

            if user:
                stored_hash = user[3]
                hashed_input = hashlib.sha256(password.encode("utf-8")).hexdigest()
                if stored_hash not in (password, hashed_input):
                    self._record_failed_login(conn, attempted_user_id=user_id, existing_user_id=user_id)
                    conn.close()
                    messagebox.showerror("Login Failed", "Invalid password")
                    return

                self.current_user = user_id
                
                # Insert successful login to audit_log
                cursor.execute("""
                    INSERT INTO audit_log (user_id, action, target_table, target_id)
                    VALUES (%s, 'LOGIN_SUCCESS', 'users', %s)
                """, (user_id, user_id))
                
                # Insert to security_audit_log
                cursor.execute("""
                    INSERT INTO security_audit_log (action_performed, performed_by, status, remarks)
                    VALUES (%s, %s, %s, %s)
                """, ('LOGIN_SUCCESS', user_id, 'SUCCESS', f'User {user_id} successfully logged in'))
                
                # Create system notification for successful login
                cursor.execute("""
                    INSERT INTO system_notifications (user_id, message, read_status)
                    VALUES (%s, %s, %s)
                """, (user_id, 'Welcome back!', 0))
                
                conn.commit()
                conn.close()
                self._audit_notice(f"LOGIN_SUCCESS recorded for user {user_id}")
                self.show_dashboard()
            else:
                # Insert failed login attempt to audit_log
                self._record_failed_login(conn, attempted_user_id=user_id, existing_user_id=None)
                conn.close()
                messagebox.showerror("Login Failed", "Invalid user id")
        except Exception as e:
            messagebox.showerror("Error", f"Login error: {str(e)}")
        finally:
            if conn:
                conn.close()

    # ======================== DASHBOARD ========================
    def show_dashboard(self):
        """Display main dashboard"""
        self.clear_window()

        # Top frame with user info and logout
        top_frame = ttk.Frame(self.root)
        top_frame.pack(fill=tk.X, padx=10, pady=10)

        ttk.Label(top_frame, text=f"Logged in as: {self.current_user}", 
                  font=("Helvetica", 10, "bold")).pack(side=tk.LEFT)
        ttk.Button(top_frame, text="Logout", command=self.logout).pack(side=tk.RIGHT)

        # Title
        title_label = ttk.Label(self.root, text="Dashboard - Blockchain System", 
                               font=("Helvetica", 18, "bold"))
        title_label.pack(pady=20)

        # Button frame
        button_frame = ttk.Frame(self.root)
        button_frame.pack(pady=20)

        buttons = [
            ("Add Transaction", self.show_add_transaction_window),
            ("View Blocks", self.show_view_blocks_window),
            ("View Transactions", self.show_view_transactions_window),
            ("Validate Blockchain", self.show_validate_blockchain_window),
            ("Repair Blockchain", self.show_repair_blockchain_window),
            ("View Audit Log", self.show_audit_log_window),
            ("Exit", self.on_exit)
        ]

        for i, (text, command) in enumerate(buttons):
            btn = ttk.Button(button_frame, text=text, command=command, width=25)
            btn.grid(row=i // 2, column=i % 2, padx=10, pady=10)

    # ======================== ADD TRANSACTION ========================
    def show_add_transaction_window(self):
        """Display add transaction window"""
        self.clear_window()

        back_btn = ttk.Button(self.root, text="Back to Dashboard", command=self.show_dashboard)
        back_btn.pack(pady=10)

        frame = ttk.LabelFrame(self.root, text="Add Transaction", padding="20")
        frame.pack(padx=20, pady=20, fill=tk.BOTH, expand=True)

        # Block selection
        ttk.Label(frame, text="Block Selection:", font=("Helvetica", 12, "bold")).pack(pady=10)
        
        block_frame = ttk.Frame(frame)
        block_frame.pack(pady=10)

        use_latest = tk.BooleanVar(value=True)
        ttk.Radiobutton(block_frame, text="Use Latest Block", variable=use_latest, value=True).pack()
        ttk.Radiobutton(block_frame, text="Use Specific Block ID", variable=use_latest, value=False).pack()

        ttk.Label(frame, text="Block ID (if not using latest):", font=("Helvetica", 10)).pack()
        block_id_entry = ttk.Entry(frame, width=20)
        block_id_entry.pack(pady=5)

        # Drug information
        ttk.Label(frame, text="Drug Name:", font=("Helvetica", 10)).pack(pady=(20, 5))
        drug_entry = ttk.Entry(frame, width=40)
        drug_entry.pack(pady=5)

        ttk.Label(frame, text="Dosage:", font=("Helvetica", 10)).pack(pady=(10, 5))
        dosage_entry = ttk.Entry(frame, width=40)
        dosage_entry.pack(pady=5)

        ttk.Label(frame, text="Quantity:", font=("Helvetica", 10)).pack(pady=(10, 5))
        quantity_entry = ttk.Entry(frame, width=40)
        quantity_entry.pack(pady=5)

        def add_transaction_action():
            try:
                drug = drug_entry.get().strip()
                dosage = dosage_entry.get().strip()
                quantity = quantity_entry.get().strip()

                if not drug or not dosage or not quantity:
                    messagebox.showerror("Error", "Please fill all fields")
                    return

                conn = self.connect_db()
                if not conn:
                    return

                try:
                    if use_latest.get():
                        block_id = backend.get_latest_block(conn)
                        if not block_id:
                            messagebox.showerror("Error", "No blocks found")
                            return
                    else:
                        block_id_text = block_id_entry.get().strip()
                        if not block_id_text:
                            raise ValueError("Invalid Block ID format")
                        try:
                            block_id = int(block_id_text)
                        except ValueError:
                            raise ValueError("Invalid Block ID format")

                    result = backend.add_transaction(conn, self.current_user, block_id, drug, dosage, quantity)
                    if result["sealed"]:
                        messagebox.showinfo(
                            "Success",
                            f"Transaction added to Block {block_id}\nBlock is now sealed (6 transactions)",
                        )
                    else:
                        messagebox.showinfo(
                            "Success",
                            f"Transaction added to Block {block_id}\nTransactions in block: {result['count']}/6",
                        )
                    self.show_dashboard()
                except ValueError as e:
                    messagebox.showerror("Error", str(e))
                except Exception as e:
                    messagebox.showerror("Error", f"Transaction failed: {str(e)}")
                finally:
                    if conn:
                        conn.close()

            except Exception as e:
                messagebox.showerror("Error", f"An error occurred: {str(e)}")

        ttk.Button(frame, text="Add Transaction", command=add_transaction_action).pack(pady=20)

    # ======================== VIEW BLOCKS ========================
    def show_view_blocks_window(self):
        """Display all blocks"""
        self.clear_window()

        back_btn = ttk.Button(self.root, text="Back to Dashboard", command=self.show_dashboard)
        back_btn.pack(pady=10)

        title_label = ttk.Label(self.root, text="Blockchain Blocks", font=("Helvetica", 14, "bold"))
        title_label.pack(pady=10)

        # Create text widget with scrollbar
        text_frame = ttk.Frame(self.root)
        text_frame.pack(padx=20, pady=10, fill=tk.BOTH, expand=True)

        text_widget = scrolledtext.ScrolledText(text_frame, wrap=tk.WORD, height=20, width=100)
        text_widget.pack(fill=tk.BOTH, expand=True)

        conn = self.connect_db()
        if conn:
            try:
                blocks = backend.get_blocks(conn)

                if blocks:
                    text_widget.insert(tk.END, f"{'Block ID':<10} {'Previous Hash':<15} {'Block Hash':<15} {'Sealed':<8} {'Created At':<20}\n")
                    text_widget.insert(tk.END, "-" * 80 + "\n")
                    for block in blocks:
                        text_widget.insert(tk.END, f"{str(block[0]):<10} {str(block[1])[:15]:<15} {str(block[2])[:15]:<15} {str(block[3]):<8} {str(block[4]):<20}\n")
                else:
                    text_widget.insert(tk.END, "No blocks found in the blockchain.")
            except Exception as e:
                text_widget.insert(tk.END, f"Error: {str(e)}")
            finally:
                conn.close()

        text_widget.config(state=tk.DISABLED)

    # ======================== VIEW TRANSACTIONS ========================
    def show_view_transactions_window(self):
        """Display all transactions"""
        self.clear_window()

        back_btn = ttk.Button(self.root, text="Back to Dashboard", command=self.show_dashboard)
        back_btn.pack(pady=10)

        title_label = ttk.Label(self.root, text="Blockchain Transactions", font=("Helvetica", 14, "bold"))
        title_label.pack(pady=10)

        text_frame = ttk.Frame(self.root)
        text_frame.pack(padx=20, pady=10, fill=tk.BOTH, expand=True)

        text_widget = scrolledtext.ScrolledText(text_frame, wrap=tk.WORD, height=20, width=100)
        text_widget.pack(fill=tk.BOTH, expand=True)

        conn = self.connect_db()
        if conn:
            try:
                transactions = backend.get_transactions(conn, limit=100)

                if transactions:
                    text_widget.insert(tk.END, f"{'TX ID':<8} {'Block ID':<10} {'User ID':<10} {'Data':<40} {'Created At':<20}\n")
                    text_widget.insert(tk.END, "-" * 90 + "\n")
                    for tx in transactions:
                        data = str(tx[3])[:40] if tx[3] else "N/A"
                        text_widget.insert(tk.END, f"{str(tx[0]):<8} {str(tx[1]):<10} {str(tx[2]):<10} {data:<40} {str(tx[4]):<20}\n")
                else:
                    text_widget.insert(tk.END, "No transactions found.")
            except Exception as e:
                text_widget.insert(tk.END, f"Error: {str(e)}")
            finally:
                conn.close()

        text_widget.config(state=tk.DISABLED)

    # ======================== VALIDATE BLOCKCHAIN ========================
    def show_validate_blockchain_window(self):
        """Validate blockchain integrity"""
        self.clear_window()

        back_btn = ttk.Button(self.root, text="Back to Dashboard", command=self.show_dashboard)
        back_btn.pack(pady=10)

        title_label = ttk.Label(self.root, text="Blockchain Validation", font=("Helvetica", 14, "bold"))
        title_label.pack(pady=10)

        text_frame = ttk.Frame(self.root)
        text_frame.pack(padx=20, pady=10, fill=tk.BOTH, expand=True)

        text_widget = scrolledtext.ScrolledText(text_frame, wrap=tk.WORD, height=20, width=100)
        text_widget.pack(fill=tk.BOTH, expand=True)

        conn = self.connect_db()
        if conn:
            try:
                results = backend.validate_blockchain(conn)

                if results:
                    text_widget.insert(tk.END, f"{'Block ID':<12} {'Hash Status':<20} {'Chain Status':<20}\n")
                    text_widget.insert(tk.END, "-" * 55 + "\n")
                    for row in results:
                        text_widget.insert(tk.END, f"{str(row[0]):<12} {str(row[1]):<20} {str(row[2]):<20}\n")
                    
                    text_widget.insert(tk.END, "\n" + "="*55 + "\n")
                    text_widget.insert(tk.END, "Validation complete. Check status above.\n")
                else:
                    text_widget.insert(tk.END, "No blocks to validate.")
            except Exception as e:
                text_widget.insert(tk.END, f"Error: {str(e)}")
            finally:
                conn.close()

        text_widget.config(state=tk.DISABLED)

    # ======================== REPAIR BLOCKCHAIN ========================
    def show_repair_blockchain_window(self):
        """Repair blockchain"""
        self.clear_window()

        back_btn = ttk.Button(self.root, text="Back to Dashboard", command=self.show_dashboard)
        back_btn.pack(pady=10)

        frame = ttk.Frame(self.root)
        frame.pack(expand=True)

        title_label = ttk.Label(frame, text="Repair Blockchain", font=("Helvetica", 16, "bold"))
        title_label.pack(pady=20)

        info_label = ttk.Label(frame, text="This will recalculate and repair all block hashes.\nContinue?", 
                              font=("Helvetica", 11))
        info_label.pack(pady=20)

        def repair_action():
            conn = self.connect_db()
            if conn:
                try:
                    backend.repair_blockchain(conn, user_id=self.current_user)
                    messagebox.showinfo("Success", "Blockchain has been repaired successfully!")
                    self.show_dashboard()
                except Exception as e:
                    messagebox.showerror("Error", f"Repair failed: {str(e)}")
                finally:
                    conn.close()

        def cancel_action():
            self.show_dashboard()

        button_frame = ttk.Frame(frame)
        button_frame.pack(pady=20)

        ttk.Button(button_frame, text="Repair", command=repair_action).pack(side=tk.LEFT, padx=10)
        ttk.Button(button_frame, text="Cancel", command=cancel_action).pack(side=tk.LEFT, padx=10)

    # ======================== AUDIT LOG ========================
    def show_audit_log_window(self):
        """Display audit log"""
        self.clear_window()

        back_btn = ttk.Button(self.root, text="Back to Dashboard", command=self.show_dashboard)
        back_btn.pack(pady=10)

        title_label = ttk.Label(self.root, text="Audit Log", font=("Helvetica", 14, "bold"))
        title_label.pack(pady=10)

        text_frame = ttk.Frame(self.root)
        text_frame.pack(padx=20, pady=10, fill=tk.BOTH, expand=True)

        text_widget = scrolledtext.ScrolledText(text_frame, wrap=tk.WORD, height=20, width=100)
        text_widget.pack(fill=tk.BOTH, expand=True)

        conn = self.connect_db()
        if conn:
            cursor = conn.cursor()
            try:
                cursor.execute("SELECT log_id, user_id, action, target_table, target_id, timestamp FROM audit_log ORDER BY log_id DESC LIMIT 100")
                logs = cursor.fetchall()

                if logs:
                    text_widget.insert(tk.END, f"{'Log ID':<8} {'User ID':<10} {'Action':<20} {'Table':<20} {'Target ID':<12} {'Timestamp':<20}\n")
                    text_widget.insert(tk.END, "-" * 95 + "\n")
                    for log in logs:
                        text_widget.insert(tk.END, f"{str(log[0]):<8} {str(log[1] or 'N/A'):<10} {str(log[2]):<20} {str(log[3]):<20} {str(log[4] or 'N/A'):<12} {str(log[5]):<20}\n")
                else:
                    text_widget.insert(tk.END, "No audit logs found.")
            except Exception as e:
                text_widget.insert(tk.END, f"Error: {str(e)}")
            finally:
                conn.close()

        text_widget.config(state=tk.DISABLED)

    # ======================== LOGOUT & EXIT ========================
    def logout(self):
        """Logout user"""
        conn = self.connect_db()
        if conn:
            cursor = conn.cursor()
            try:
                # Insert to audit_log
                cursor.execute("""
                    INSERT INTO audit_log (user_id, action, target_table, target_id)
                    VALUES (%s, 'LOGOUT', 'users', %s)
                """, (self.current_user, self.current_user))
                
                # Insert to security_audit_log
                cursor.execute("""
                    INSERT INTO security_audit_log (action_performed, performed_by, status, remarks)
                    VALUES (%s, %s, %s, %s)
                """, ('LOGOUT', self.current_user, 'SUCCESS', f'User {self.current_user} logged out'))
                
                # Create system notification for logout
                cursor.execute("""
                    INSERT INTO system_notifications (user_id, message, read_status)
                    VALUES (%s, %s, %s)
                """, (self.current_user, 'You have been logged out', 0))
                
                conn.commit()
            except:
                pass
            finally:
                conn.close()
        
        self._audit_notice(f"LOGOUT recorded for user {self.current_user}")
        self.current_user = None
        self.show_login_window()

    def on_exit(self):
        """Exit application"""
        conn = self.connect_db()
        if conn:
            cursor = conn.cursor()
            try:
                # Insert to audit_log
                cursor.execute("""
                    INSERT INTO audit_log (user_id, action, target_table, target_id)
                    VALUES (%s, 'EXIT', 'users', %s)
                """, (self.current_user, self.current_user))
                
                # Insert to security_audit_log
                cursor.execute("""
                    INSERT INTO security_audit_log (action_performed, performed_by, status, remarks)
                    VALUES (%s, %s, %s, %s)
                """, ('APPLICATION_EXIT', self.current_user, 'SUCCESS', f'User {self.current_user} exited application'))
                
                conn.commit()
            except:
                pass
            finally:
                conn.close()
        
        self._audit_notice(f"EXIT recorded for user {self.current_user}")
        self.root.quit()

if __name__ == "__main__":
    root = tk.Tk()
    app = BlockchainApp(root)
    root.mainloop()
