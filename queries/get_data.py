# from db.db_connection import run_query
from db.db_connection import connect_to_db
import pandas as pd

def get_customer_full_view():
    conn = connect_to_db()
    query = "SELECT * FROM customer_full_view;"
    df = pd.read_sql(query, conn)
    conn.close()
    return df

# def get_low_revenue_data():
#     query = "SELECT * FROM low_revenue_view;"
#     return run_query(query)
