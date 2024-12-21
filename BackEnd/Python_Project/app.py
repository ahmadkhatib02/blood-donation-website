from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS
import bcrypt
from functools import wraps
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import pymysql


app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing (optional for frontend-backend separation)

# Configuring MySQL database
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'  # Change to your MySQL username
app.config['MYSQL_PASSWORD'] = 'ahmadkhatib18'  # Change to your MySQL password
app.config['MYSQL_DB'] = 'blooddonation'

mysql = MySQL(app)

# Helper function to check authentication (example for login) 
def token_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'message': 'Token is missing'}), 403
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM individual WHERE password=%s", (token,))
            user = cur.fetchone()
            if not user:
                return jsonify({'message': 'Token is invalid'}), 403
        except:
            return jsonify({'message': 'Error checking token'}), 500
        return f(user, *args, **kwargs)
    return decorated_function

# Route for user login (authentication) FOR DONOR 
@app.route('/login', methods=['POST'])
def donor_login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'message': 'Email and password are required'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM individual WHERE email=%s", (email,))
    user = cur.fetchone()

    if not user:
        return jsonify({'message': 'User not found'}), 404

    # Check if password matches (assuming bcrypt is used for hashing passwords)
    if bcrypt.checkpw(password.encode('utf-8'), user[6].encode('utf-8')):  # user[6] is the password field
        return jsonify({'message': 'Login successful'}), 200
    else:
        return jsonify({'message': 'Invalid password'}), 400

# Route for healthcare professional login (authentication) 
@app.route('/health_Care_Professional/login', methods=['POST'])
def health_Care_Professional_login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'message': 'Email and password are required'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Health_Care_Professional WHERE email=%s", (email,))
    health_Care_Professional = cur.fetchone()

    if not health_Care_Professional:
        return jsonify({'message': 'Healthcare professional not found'}), 404

    # Check if password matches (assuming bcrypt is used for hashing passwords)
    if bcrypt.checkpw(password.encode('utf-8'), health_Care_Professional[4].encode('utf-8')):  # hc_professional[4] is the password field
        return jsonify({'message': 'Login successful'}), 200
    else:
        return jsonify({'message': 'Invalid password'}), 400

# registering the donors
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    
    # Extract fields from the JSON payload
    firstName = data.get('firstName')
    lastName = data.get('lastName')
    password = data.get('password')
    phoneNumber = data.get('phoneNumber')
    email = data.get('email')
    gender = data.get('gender')
    city = data.get('city')
    blood_type = data.get('blood_type')
    rhesus = data.get('rhesus')

    # Check if all required fields are provided
    if not all([firstName, lastName, email, password, city, phoneNumber, gender, blood_type, rhesus]):
        return jsonify({'error': {'code': 400, 'message': 'All fields are required'}}), 400

    # Validate email format (basic regex)
    import re
    if not re.match(r'[^@]+@[^@]+\.[^@]+', email):
        return jsonify({'error': {'code': 400, 'message': 'Invalid email format'}}), 400

    # Validate password length
    if len(password) < 6:
        return jsonify({'error': {'code': 400, 'message': 'Password must be at least 6 characters long'}}), 400

    # Hash the password
    hashed_pw = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    cur = mysql.connection.cursor()
    try:
        # Insert user details into the individual table
        cur.execute(
            "INSERT INTO individual (email, firstName, lastName, gender, phoneNumber, city, password) "
            "VALUES (%s, %s, %s, %s, %s, %s, %s)",
            (email, firstName, lastName, gender, phoneNumber, city, hashed_pw.decode('utf-8'))
        )
        cur.execute(
            "INSERT INTO donor (blood_type, rhesus, email) "
            "VALUES (%s, %s, %s)",
            (blood_type, rhesus, email)
        )
        mysql.connection.commit()
        return jsonify({'message': 'User registered successfully'}), 201
    except pymysql.err.IntegrityError:
        # Handle duplicate email errors
        return jsonify({'error': {'code': 400, 'message': 'Email already exists'}}), 400
    except Exception as e:
        # Handle other database errors
        mysql.connection.rollback()
        return jsonify({'error': {'code': 500, 'message': f'Error: {str(e)}'}}), 500


# Route for getting user profile (protected route) 
@app.route('/profile', methods=['GET'])
@token_required
def profile(user):
    return jsonify({'user': {'firstName': user[1], 'lastName': user[2], 'email': user[3]}}), 200

# Adding recipient 
@app.route('/add_recipient', methods=['POST'])
def add_recipient():
    data = request.get_json()
    firstName = data.get('firstName')
    lastName = data.get('lastName')
    blood_type = data.get('bloodGroup')
    rhesus = data.get('rhesus')
    email = data.get('email')

     # Debugging for missing fields
    print("First Name:", firstName)
    print("Last Name:", lastName)
    print("Blood Type:", blood_type)
    print("Rhesus:", rhesus)
    print("Email:", email)

    if not all([firstName, lastName, blood_type, rhesus, email]):
        return jsonify({'message': 'All fields are required'}), 400

    cur = mysql.connection.cursor()
    try:
        # Insert recipient data into the recipient table
        cur.execute(
            "INSERT INTO recipient (firstName, lastName, blood_type, rhesus, email) "
            "VALUES (%s, %s, %s, %s, %s)",
            (firstName, lastName, blood_type, rhesus, email)
        )
        recipient_id = cur.lastrowid
        mysql.connection.commit()
        return jsonify({'message': 'Recipient added successfully', "recipient_id": recipient_id}), 201

    except Exception as e:
        # Rollback in case of error
        mysql.connection.rollback()
        return jsonify({'message': f'Error: {str(e)}'}), 500
    finally:
        # Close the cursor
        cur.close()

# Route for listing all branches 
@app.route('/branches', methods=['GET'])
def branches():
    cur = mysql.connection.cursor()
    try:
        cur.execute("SELECT * FROM branch")
        branches = cur.fetchall()
        return jsonify({'branches': branches}), 200
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500

# Route for listing all available blood units 
@app.route('/blood_units', methods=['GET'])
def blood_units():
    cur = mysql.connection.cursor()
    try:
        cur.execute("SELECT * FROM blood_unit_tobedonated")
        blood_units = cur.fetchall()
        return jsonify({'blood_units': blood_units}), 200
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500

# Route for listing donors
@app.route('/donors', methods=['GET'])
def donors():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM donor")
    donors = cur.fetchall()
    return jsonify({'donors': donors}), 200

# store the order of blood and recipient - idk if useful
def store_order(cursor, blood_id, recipient_id, branch_id):
    try:
        query = """
        INSERT INTO orders (blood_ID, recipient_ID, branch_ID)
        VALUES (%s, %s, %s)
        """
        cursor.execute(query, (blood_id, recipient_id, branch_id))
        print("Order stored successfully.")
    except mysql.connector.Error as err:
        print(f"Error: {err}")

# get the donor info - blood type and such 
def get_donor_info(cursor, donor_id):
    try:
        query = """
        SELECT d.donor_ID, i.firstName, i.lastName, i.email, d.blood_type, d.rhesus
        FROM donor d
        JOIN individual i ON d.email = i.email
        WHERE d.donor_ID = %s
        """
        cursor.execute(query, (donor_id,))
        return cursor.fetchone()
    except mysql.connector.Error as err:
        print(f"Error: {err}")

# get recipient info  
def get_recipient_info(cursor, recipient_id):
    try:
        query = """
        SELECT recipient_ID, firstName, lastName, blood_type, rhesus, email, branch_ID
        FROM recipient
        WHERE recipient_ID = %s
        """
        cursor.execute(query, (recipient_id,))
        return cursor.fetchone()
    except mysql.connector.Error as err:
        print(f"Error: {err}")


# get organization info 
def get_organization_info(cursor, branch_id):
    try:
        query = """
        SELECT branch_ID, branch_name, phoneNumber, city, street
        FROM branch
        WHERE branch_ID = %s
        """
        cursor.execute(query, (branch_id,))
        return cursor.fetchone()
    except mysql.connector.Error as err:
        print(f"Error: {err}")

# matching both donor and recipient for the hc_professional page - waiting for front-end

# check if qualified through blood sample test
@app.route('/add_blood_sample_test', methods=['POST'])
def add_blood_sample_test():
    data = request.get_json()
    print("Received Data:", data)
    
    # Extract data 
    appointment_Date = data.get('appointment_Date')
    sobriety = data.get('sobriety')
    last_donated_date = data.get('last_Donated_Date')  
    disease = data.get('disease') 
    hemoglobin = data.get('hemoglobin')
    iron_levels = data.get('iron_levels')
    isQualified = data.get('isQualified') 

    print("Extracted Values:")
    print("appointment_Date:", appointment_Date)
    print("sobriety:", sobriety)
    print("hemoglobin:", hemoglobin)
    print("iron_levels:", iron_levels)
    print("is_Qualified:", isQualified)

    # Validate required fields
    if not all([appointment_Date, sobriety, hemoglobin, iron_levels, isQualified]):
        return jsonify({'error': 'All required fields must be provided'}), 400

    # Database inserting valus
    cur = mysql.connection.cursor()
    try:
        # Insert data into the Blood_Sample_Test table
        cur.execute(
            """
            INSERT INTO Blood_Sample_Test (
                appointment_Date, sobriety, last_Donated_Date, disease, 
                hemoglobin, iron_levels, isQualified
            ) 
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (appointment_Date, sobriety, last_donated_date, disease, hemoglobin, iron_levels, 
                isQualified
            )
        )
        mysql.connection.commit()
        return jsonify({'message': 'Blood sample test added successfully'}), 201
    except pymysql.err.IntegrityError:
        # Handle cases like invalid foreign keys or duplicate entries
        return jsonify({'error': 'Invalid donor ID or blood ID'}), 400
    except Exception as e:
        # Handle other database errors
        mysql.connection.rollback()
        return jsonify({'error': f'Error: {str(e)}'}), 500
    finally:
        cur.close()

# Fill the blood unit to be donated - only if isQualified
@app.route('/add_blood_unit', methods=['POST'])
def add_blood_unit():
    data = request.get_json()

    # Extract data from the request payload
    donor_ID = data.get('donor_ID')
    recipient_ID = data.get('recipient_ID')
    branch_Name = data.get('branch_Name')  # Branch name provided by the frontend
    blood_type = data.get('blood_type')  # ENUM values: 'A', 'B', 'AB', 'O'
    rhesus = data.get('rhesus')  # ENUM values: '+', '-'

    # Validate required fields
    if not all([donor_ID, recipient_ID, branch_Name, blood_type, rhesus]):
        return jsonify({'error': 'All required fields must be provided'}), 400

    # Validate ENUM values for blood_type and rhesus
    if blood_type not in ['A', 'B', 'AB', 'O'] or rhesus not in ['+', '-']:
        return jsonify({'error': 'Invalid blood type or rhesus value'}), 400

    cur = mysql.connection.cursor()
    try:
        # Step 1: Check if the donor is qualified
        cur.execute("SELECT isQualified FROM Donor WHERE donor_ID = %s", (donor_id,))
        result = cur.fetchone()

        if not result:
            return jsonify({'error': 'Donor not found'}), 404

        is_qualified = result['isQualified']

        if is_qualified != 'yes':
            return jsonify({'error': 'Donor is not qualified to donate blood'}), 400

        # Step 2: Fetch the branch_id based on branch_name
        cur.execute("SELECT branch_ID FROM Branch WHERE branch_Name = %s", (branch_Name,))
        branch_result = cur.fetchone()

        if not branch_result:
            return jsonify({'error': 'Invalid branch name'}), 400

        branch_ID = branch_result['branch_ID']

        # Step 3: Insert into blood_unit_tobedonated table
        cur.execute(
            """
            INSERT INTO blood_unit_tobedonated (blood_type, rhesus, donor_ID, recipient_ID, branch_ID)
            VALUES (%s, %s, %s, %s, %s)
            """,
            (blood_type, rhesus, donor_ID, recipient_ID, branch_ID)
        )
        mysql.connection.commit()
        return jsonify({'message': 'Blood unit added successfully'}), 201

    except Exception as e:
        # Rollback in case of error
        mysql.connection.rollback()
        return jsonify({'error': f'Error: {str(e)}'}), 500
    finally:
        cur.close()

# when the user will click, an email will be sent - works 
def send_email(recipient_email, subject, body): 
    sender_email = "sawablood@gmail.com"
    sender_password = "SawaBlood@december19" # not very safe to type it in code but too complicated to do it in another way
    
    # Set up the server
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    
    # Log into the server
    server.login(sender_email, sender_password)
    
    # Create the email message
    message = MIMEMultipart()
    message['From'] = sender_email
    message['To'] = recipient_email
    message['Subject'] = subject
    message.attach(MIMEText(body, 'plain'))
    
    # Send the email
    server.sendmail(sender_email, recipient_email, message.as_string())
    
    # Close the server connection
    server.quit()

@app.route('/reserve', methods=['POST']) # will fix it after checking front-end
def reserve():
    # Check if the user is logged in
    if 'user_id' not in session:
        return jsonify({"error": "User not logged in"}), 401

    # Get reservation details from the POST request
    branch_ID = request.json.get('branch_ID')
    appointment_Date = request.json.get('appointment_Date')

    if not branch_id or not appointment_date :
        return jsonify({"error": "Branch ID and appointment date are required"}), 400

    try:
        # Connect to the MySQL database
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="ahmadkhatib18",
            database="blooddonation"
        )
        cursor = conn.cursor()

        # Check if the donor exists
        cursor.execute("SELECT email FROM donor WHERE donor_id = %s", (user_id,))
        donor = cursor.fetchone()

        if not donor:
            return jsonify({"error": "Donor not found"}), 404

        # Create a reservation
        cursor.execute(
            """
            INSERT INTO Blood_Sample_Test (appointment_Date, donor_ID) 
            VALUES (%s, %s,)
            """,
            (appointment_date, user_id, branch_id)
        )
        conn.commit()

        # Send confirmation email
        recipient_email = donor[0]
        subject = "Appointment Confirmation"
        body = f"Dear donor,\n\nYour blood donation appointment has been successfully scheduled for {appointment_date}.\n\nThank you for saving lives!\n\nSawa Blood Team"
        send_email(recipient_email, subject, body)

        return jsonify({"message": "Reservation confirmed and email sent!"}), 200

    except mysql.connector.Error as err:
        return jsonify({"error": str(err)}), 500


    # Route for listing hospitals and Red Cross locations - works
@app.route('/locations', methods=['GET'])
def locations():
    location_type = request.args.get('type')  # 'H' for hospitals, 'R' for Red Cross branches

    # Validate input type
    if not location_type or location_type not in ['H', 'R']:
        return jsonify({'message': 'Invalid or missing location type'}), 400

    cur = mysql.connection.cursor()
    try:
        # Determine query based on type
        if location_type == 'H':  # Hospitals
            query = "SELECT branch_ID, branch_name, city, street, phoneNumber FROM branch WHERE branch_name NOT LIKE 'Lebanese Red Cross%'"
        elif location_type == 'R':  # Red Cross branches
            query = "SELECT branch_ID, branch_name, city, street, phoneNumber FROM branch WHERE branch_name LIKE 'Lebanese Red Cross%'"

        # Execute query
        cur.execute(query)
        branches = cur.fetchall()

        # Format results
        result = [
            {
                'id': branch[0],
                'branch_name': branch[1],
                'city': branch[2],
                'street': branch[3],
                'phone': branch[4]
            }
            for branch in branches
        ]

        return jsonify({'locations': result}), 200
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
    finally:
        cur.close()

if __name__ == '__main__':
    app.run(debug=True)


 #Update the branch Id in the recipient when reservation
@app.route('/update_recipient', methods=['POST'])
def update_recipient():
    try:
        # Get JSON data from the request
        data = request.get_json()
        branch_ID = data.get('branch_ID')  # Retrieve branch ID
        recipient_ID = data.get('recipient_ID')
        print(branch_ID)

        # Update the recipient table in the database
        cur = mysql.connection.cursor()
        cur.execute(
            "UPDATE recipient SET branch_ID = %s WHERE recipient_ID = %s",  
            (branch_ID, recipient_ID)  # Replace with the correct condition
        )
        mysql.connection.commit()

        return jsonify({"message": "Recipient updated successfully!"}), 200
    except Exception as e:
        print("Error updating recipient:", str(e))
        return jsonify({"message": f"Error: {str(e)}"}), 500
    finally:
        if 'cur' in locals():
            cur.close()
