import streamlit as st
import psycopg2

# DB connection
def get_connection():
    return psycopg2.connect(
        host="localhost",
        database="Banking System",
        user="Bank admin",
        password="banking123"
    )

st.set_page_config(page_title="Banking System", layout="wide")
top_left, top_right = st.columns([6, 1])

with top_right:
    st.caption("🎨 Theme")
    color = st.color_picker("", "#00c896")


# ----------- CSS -----------
st.markdown(f"""
<style>

/* FULL page background */
html, body, [data-testid="stAppViewContainer"] {{
    background: linear-gradient(135deg, #081c15, #0b1410);
}}

/* Color picker size fix */
.stColorPicker {{
    transform: scale(0.8);
    transform-origin: top right;
}}

/* Card */
.card {{
    background: linear-gradient(145deg, #0f1f17, #13281e);
    padding: 18px;
    border-radius: 14px;
    margin-bottom: 12px;
    border: 1px solid {color};
    box-shadow: 0px 0px 15px {color}33;
    backdrop-filter: blur(6px);
}}

/* Buttons */
.stButton>button {{
    border-radius: 10px;
    height: 45px;
    width: 100%;
    font-weight: bold;
    background: {color};
    color: black;
    border: none;
}}

.stButton>button:hover {{
    opacity: 0.85;
    box-shadow: 0px 0px 15px {color}33;
}}

/* Headings */
h1, h2, h3, h4 {{
    color: {color};
}}

</style>
""", unsafe_allow_html=True)

# ----------- HEADER -----------
st.title("🏦 Mr. Sam's Banking System")
st.write("Welcome to our banking dashboard")
st.markdown("---")

# ----------- FETCH DATA -----------
conn = get_connection()
cur = conn.cursor()

cur.execute("SELECT account_id, name, balance FROM accounts ORDER BY account_id;")
accounts = cur.fetchall()

account_ids = [acc[0] for acc in accounts]

# ----------- SESSION STATE -----------
if "show_add" not in st.session_state:
    st.session_state.show_add = False

if "show_txn" not in st.session_state:
    st.session_state.show_txn = False

# ----------- MAIN LAYOUT -----------
left, right = st.columns([2, 1])

# ----------- LEFT: ACCOUNTS -----------
with left:
    colA, colB = st.columns([4, 1])

    with colA:
        st.subheader("💳 Accounts")

    with colB:
        if st.button("➕ Add"):
            st.session_state.show_add = True

    # Add account form
    if st.session_state.show_add:
        new_name = st.text_input("Enter Account Name")

        if st.button("Create Account"):
            conn = get_connection()
            cur = conn.cursor()

            cur.execute("INSERT INTO accounts (name, balance) VALUES (%s, 0);", (new_name,))
            conn.commit()

            st.success("Account created!")
            st.session_state.show_add = False
            st.rerun()

    # ----------- ACCOUNTS DISPLAY -----------
    for acc in accounts:
        acc_id, name, balance = acc

        st.markdown(f"""
        <div class="card">
            <h4>{name} (ID: {acc_id})</h4>
        </div>
        """, unsafe_allow_html=True)

        if st.button(f"Check Balance", key=f"bal_{acc_id}"):
            st.success(f"Balance: ₹ {balance}")

# ----------- RIGHT: OPERATIONS -----------
with right:
    st.subheader("💼 Actions")

    # Deposit
    st.markdown("### 💰 Deposit")
    selected_account = st.selectbox("Account", account_ids, key="dep")
    amount = st.number_input("Amount", min_value=1.0, key="dep_amt")

    if st.button("Deposit"):
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT deposit(%s, %s);", (selected_account, amount))
        conn.commit()
        st.success("Done")

    st.divider()

    # Withdraw
    st.markdown("### 🏧 Withdraw")
    selected_account_w = st.selectbox("Account", account_ids, key="with")
    amount_w = st.number_input("Amount", min_value=1.0, key="with_amt")

    if st.button("Withdraw"):
        conn = get_connection()
        cur = conn.cursor()

        try:
            cur.execute("SELECT withdraw(%s, %s);", (selected_account_w, amount_w))
            conn.commit()
            st.success("Done")
        except:
            st.error("Insufficient balance")

    st.divider()

    # Transfer
    st.markdown("### 🔄 Transfer")
    sender = st.selectbox("From", account_ids, key="sender")
    receiver = st.selectbox("To", account_ids, key="receiver")
    amount_t = st.number_input("Amount", min_value=1.0, key="trans_amt")

    if st.button("Transfer"):
        if sender == receiver:
            st.error("Same account not allowed")
        else:
            conn = get_connection()
            cur = conn.cursor()

            try:
                cur.execute("SELECT transfer(%s, %s, %s);", (sender, receiver, amount_t))
                conn.commit()
                st.success("Done")
            except:
                st.error("Transfer failed")

# ----------- TRANSACTION HISTORY TOGGLE -----------
st.markdown("---")

if st.button("📜 Show / Hide Transaction History"):
    st.session_state.show_txn = not st.session_state.show_txn

if st.session_state.show_txn:
    st.subheader("📜 Transaction History")

    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT a.name, t.type, t.amount, t.transaction_date
        FROM transactions t
        JOIN accounts a ON t.account_id = a.account_id
        ORDER BY t.transaction_date DESC;
    """)

    transactions = cur.fetchall()

    for t in transactions:
        name, t_type, amount, date = t

        st.markdown(f"""
        <div class="card">
            <b>{name}</b> | {t_type} <br>
            ₹ {amount} <br>
            <small>{date}</small>
        </div>
        """, unsafe_allow_html=True)
