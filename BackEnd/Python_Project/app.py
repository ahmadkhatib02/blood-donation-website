from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS
import bcrypt
from functools import wraps
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing (optional for frontend-backend separation)

# Configuring MySQL database
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'  # Change to your MySQL username
app.config['MYSQL_PASSWORD'] = 'ahmadkhatib18'  # Change to your MySQL password
app.config['MYSQL_DB'] = 'blooddonation'

mysql = MySQL(app)

# Helper function to check authentication (example for login) - works
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

# Route for user login (authentication) FOR DONOR - works
@app.route('/login', methods=['POST'])
def login():
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

# Route for healthcare professional login (authentication) - works
@app.route('/hc_professional/login', methods=['POST'])
def hc_professional_login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'message': 'Email and password are required'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM hc_professional WHERE email=%s", (email,))
    hc_professional = cur.fetchone()

    if not hc_professional:
        return jsonify({'message': 'Healthcare professional not found'}), 404

    # Check if password matches (assuming bcrypt is used for hashing passwords)
    if bcrypt.checkpw(password.encode('utf-8'), hc_professional[4].encode('utf-8')):  # hc_professional[4] is the password field
        return jsonify({'message': 'Login successful'}), 200
    else:
        return jsonify({'message': 'Invalid password'}), 400

# Registering the donors - works
@app.route('/register', methods=['POST']) 
def register():
    data = request.get_json()
    
    first_name = data.get('firstName')
    last_name = data.get('lastName')
    email = data.get('email')
    password = data.get('password')
    city = data.get('city')
    phoneNumber = data.get('phoneNumber')
    gender = data.get('gender')

    if not all([first_name, last_name, email, password, city, phoneNumber, gender]):
        return jsonify({'message': 'All fields are required'}), 400

    # Hash the password before storing it
    hashed_pw = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    # Insert the new user into the database
    cur = mysql.connection.cursor()
    try:
        # Insert all user details into the individual table
        cur.execute("INSERT INTO individual (first_Name, last_Name, gender, phoneNumber, email, password, city) "
                    "VALUES (%s, %s, %s, %s, %s, %s, %s)",
                    (first_name, last_name, gender, phoneNumber, email, hashed_pw.decode('utf-8'), city))
        mysql.connection.commit()
        return jsonify({'message': 'User registered successfully'}), 201
    except Exception as e:
        # Rollback the transaction in case of an error
        mysql.connection.rollback()
        return jsonify({'message': f'Error: {str(e)}'}), 500

# Route for getting user profile (protected route) - works
@app.route('/profile', methods=['GET'])
@token_required
def profile(user):
    return jsonify({'user': {'first_Name': user[1], 'last_Name': user[2], 'email': user[3]}}), 200

# Adding recipient - works
@app.route('/add_recipient', methods=['POST'])
def add_recipient():
    data = request.get_json()
    blood_type = data.get('blood-type')
    email = data.get('email')
    first_name = data.get('firstName')
    last_name = data.get('lastName')
    city = data.get('cities')  # Get 'cities' from frontend

    if not all([blood_type, email, first_name, last_name, city]):
        return jsonify({'message': 'All fields are required'}), 400

    cur = mysql.connection.cursor()
    try:
        # Insert all the required fields into the recipient table
        cur.execute(
            "INSERT INTO recipient (blood_type, email, first_name, last_name, city) VALUES (%s, %s, %s, %s, %s)",
            (blood_type, email, first_name, last_name, city))  # 'city' is used in the SQL query
        mysql.connection.commit()
        return jsonify({'message': 'Recipient added successfully'}), 201
    except Exception as e:
        mysql.connection.rollback()
        return jsonify({'message': f'Error: {str(e)}'}), 500
    finally:
        cur.close()

# Route for listing all branches - works
@app.route('/branches', methods=['GET'])
def branches():
    cur = mysql.connection.cursor()
    try:
        cur.execute("SELECT * FROM branch")
        branches = cur.fetchall()
        return jsonify({'branches': branches}), 200
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500

# Route for listing all available blood units - works
@app.route('/blood_units', methods=['GET'])
def blood_units():
    cur = mysql.connection.cursor()
    try:
        cur.execute("SELECT * FROM blood_unit_tobedonated")
        blood_units = cur.fetchall()
        return jsonify({'blood_units': blood_units}), 200
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500

# Route for listing donors - works
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

# get the donor info - blood type and such - works
def get_donor_info(cursor, donor_id):
    try:
        query = """
        SELECT d.donor_ID, i.first_Name, i.last_Name, i.email, d.blood_type, d.rhesus
        FROM donor d
        JOIN individual i ON d.email = i.email
        WHERE d.donor_ID = %s
        """
        cursor.execute(query, (donor_id,))
        return cursor.fetchone()
    except mysql.connector.Error as err:
        print(f"Error: {err}")

# get recipient info such as blood type - works
def get_recipient_info(cursor, recipient_id):
    try:
        query = """
        SELECT recipient_ID, first_Name, last_Name, email, blood_type, city
        FROM recipient
        WHERE recipient_ID = %s
        """
        cursor.execute(query, (recipient_id,))
        return cursor.fetchone()
    except mysql.connector.Error as err:
        print(f"Error: {err}")


# get organization info - works
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

# matching both donor and recipient for the hc_professional page 

# get the info of the individual to the donor

# add the apptdate 

# isQualified implementation - depends on how we will use it!!!
@app.route('/update_qualification', methods=['POST'])
def update_qualification():
    data = request.get_json()
    
    donor_id = data.get('donor_id')
    isQualified = data.get('isQualified')
    
    if donor_id is None or isQualified is None:
        return jsonify({'message': 'Donor ID and qualification status are required'}), 400
    
    if isQualified not in [0, 1]:
        return jsonify({'message': 'Qualification status must be 0 or 1'}), 400
    
    cur = mysql.connection.cursor()
    try:
        # Update the isQualified field in the donor table
        query = "UPDATE donor SET isQualified = %s WHERE donor_id = %s"
        cur.execute(query, (isQualified, donor_id))
        mysql.connection.commit()
        
        return jsonify({'message': f'Donor qualification status updated to {isQualified}'}), 200
    except Exception as e:
        mysql.connection.rollback()
        return jsonify({'message': f'Error: {str(e)}'}), 500
    finally:
        cur.close()


def send_email(recipient_email, subject, body): #works
    sender_email = "sawablood@gmail.com"
    sender_password = "SawaBlood@december19"
    
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

@app.route('/reserve', methods=['POST']) #idk
def reserve():
    # Check if the user is logged in
    if 'user_id' not in session:
        return jsonify({"error": "User not logged in"}), 401

    # Get reservation details from the POST request
    branch_id = request.json.get('branch_id')
    appointment_date = request.json.get('appointment_date')
    hc_professional_id = request.json.get('hc_professional_id')

    if not branch_id or not appointment_date or not hc_professional_id:
        return jsonify({"error": "Branch ID, appointment date, and healthcare professional ID are required"}), 400

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
            INSERT INTO appointment (appointment_date, donor_id, branch_id, hc_professional_id) 
            VALUES (%s, %s, %s, %s)
            """,
            (appointment_date, user_id, branch_id, hc_professional_id)
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
