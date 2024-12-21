import mysql.connector

# Establishing connection to the database
connection = mysql.connector.connect(
    host="localhost",           # Database host, typically 'localhost' for local MySQL
    user="root",       # Your MySQL username
    password="ahmadkhatib18",   # Your MySQL password
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

def process_qualified_donors(cursor):
    try:
        # Step 1: Find all qualified blood samples
        cursor.execute('''
        SELECT donor_ID
        FROM blood_sample_test
        WHERE isQualified = 'yes'
        ''')
        qualified_donors = cursor.fetchall()

        if not qualified_donors:
            print("No qualified donors found.")
            return  # Exit if no donors

        # Step 2: Process each qualified donor
        for donor in qualified_donors:
            donor_ID = donor[0]

            # Get donor blood type and rhesus
            cursor.execute('''
            SELECT blood_type, rhesus
            FROM donor
            WHERE donor_ID = %s
            ''', (donor_ID,))
            donor_data = cursor.fetchone()

            if donor_data:
                blood_type, rhesus = donor_data

                # Step 3: Insert data into 'blood_unit_tobedonated' table
                cursor.execute('''
                INSERT INTO blood_unit_tobedonated (blood_type, rhesus, donor_ID, recipient_ID, branch_ID)
                VALUES (%s, %s, %s, 7, 1)
                ''', (blood_type, rhesus, donor_ID))

        print("Qualified donors' data has been successfully processed.")

    except Exception as e:
        print(f"Error in process_qualified_donors: {e}")
        raise  # Reraise the exception for the caller to handle

try:
    # Connect to the database
    conn = mysql.connector.connect(
        host="localhost",  # Replace with your DB host
        user="root",  # Replace with your DB username
        password="ahmadkhatib18",  # Replace with your DB password
        database="blooddonation"  # Replace with your DB name
    )
    cursor = conn.cursor()

    # Call the function
    process_qualified_donors(cursor)

    # Commit the transaction
    conn.commit()
    print("Transaction committed successfully.")

except mysql.connector.Error as e:
    print(f"Database connection error: {e}")
    if conn:
        conn.rollback()  # Rollback if there's an error

finally:
    # Close the database connection
    if cursor:
        cursor.close()
    if conn:
        conn.close()