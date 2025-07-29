import psycopg2

def connect_to_db():
    return psycopg2.connect(
        host="localhost",
        database="sample_riyadh",
        user="postgres",  
        password="admin", 
        port="5432"
    )
