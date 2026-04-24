# 🏦 Banking System (PostgreSQL + Streamlit)

## 📌 Overview

This project is a simple Banking System built using **PostgreSQL** for backend database operations and **Streamlit** for the user interface.

It allows users to perform core banking operations such as deposits, withdrawals, transfers, and account management through a clean and interactive UI.

---

## 🚀 Features

* 💳 Create new bank accounts
* 💰 Deposit money
* 🏧 Withdraw money (with balance validation)
* 🔄 Transfer funds between accounts
* 📜 View transaction history
* 🎨 Dynamic UI theme (color picker)
* ➕ Add new accounts dynamically

---

## 🛠️ Tech Stack

* **Frontend:** Streamlit
* **Backend:** PostgreSQL
* **Language:** Python
* **Database Connector:** psycopg2

---

## 🗄️ Database Design

The system uses the following tables:

### Accounts Table

* `account_id` (Primary Key)
* `name`
* `balance`
* `created_at`

### Transactions Table

* `transaction_id` (Primary Key)
* `account_id` (Foreign Key)
* `type`
* `amount`
* `transaction_date`

---

## ⚙️ Functionalities (Stored Procedures)

* `deposit(account_id, amount)`
* `withdraw(account_id, amount)`
* `transfer(sender_id, receiver_id, amount)`

These functions ensure:

* Data consistency
* Balance validation
* Transaction logging

---

## 🖥️ How to Run
### 1. Createa a Virtual Environment Install dependencies
## 🐍 Setup Virtual Environment

### Create venv

```bash
python -m venv .venv
```

### Activate

* **Windows (PowerShell)**

```powershell
.\.venv\Scripts\Activate.ps1
```

* **Windows (CMD)**

```cmd
.venv\Scripts\activate
```

* **macOS/Linux**

```bash
source .venv/bin/activate
```
### Install Streamlit:

```bash
pip install streamlit psycopg2-binary
```

### 2. Setup PostgreSQL

* Create a database
* Create tables (`accounts`, `transactions`)
* Add stored functions

### 3. Update DB credentials

Edit `app.py`:

```python
database="Banking System",
user="your_user",
password="your_password"
```

### 4. Run the app

```bash
streamlit run app.py
```

## 🎯 Key Highlights

* Uses **PL/pgSQL functions** for business logic
* Clean separation of **UI and database logic**
* Real-time updates with Streamlit
* User-friendly interface with modern styling

---

## 📚 Learning Outcomes

* Hands-on experience with PostgreSQL
* Understanding of stored procedures and transactions
* Building interactive dashboards using Streamlit
* Integrating frontend with database systems

---

## 👤 Author

**Kunal Gupta**

---

## ⭐ Acknowledgment

This project was developed as part of a DBMS coursework project.
