import mysql.connector

db_config = {
    'host': 'your-database-host',  # Replace with your actual host
    'user': 'your-database-username',  # Replace with your username
    'password': 'your-database-password',  # Replace with your password
    'database': 'blood_donation'  # Replace with your actual database name
}

def connect_to_db():
    try:
        # Establishing the connection
        connection = mysql.connector.connect(**db_config)
        if connection.is_connected():
            print("Connected to the database successfully!")
            cursor = connection.cursor()
            cursor.execute("SELECT * FROM donations;")  # Replace with your actual query
            results = cursor.fetchall()
            for row in results:
                print(row)
            cursor.close()
            connection.close()
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        if connection.is_connected():
            connection.close()

if __name__ == "__main__":
    connect_to_db()
