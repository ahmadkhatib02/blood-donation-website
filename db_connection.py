import mysql.connector

# Establishing connection to the database
connection = mysql.connector.connect(
    host="localhost",           # Database host, typically 'localhost' for local MySQL
    user="your_username",       # Your MySQL username
    password="your_password",   # Your MySQL password
    database="blooddonation"    # Name of the database you want to connect to
)

# Checking if the connection is successful
if connection.is_connected():
    print("Connected to the database")

# Example query: Fetching all records from the 'branch' table
cursor = connection.cursor()
cursor.execute("SELECT * FROM branch;")

# Fetching the results and printing them
records = cursor.fetchall()
for record in records:
    print(record)

# Closing the cursor and connection
cursor.close()
connection.close()
