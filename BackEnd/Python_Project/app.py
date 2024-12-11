from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS
import bcrypt
import datetime
from functools import wraps

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

# Route for user login (authentication)
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

# Route for registering a new user
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    first_name = data.get('firstName')
    last_name = data.get('lastName')
    email = data.get('email')
    password = data.get('password')

    if not all([first_name, last_name, email, password]):
        return jsonify({'message': 'All fields are required'}), 400

    hashed_pw = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    cur = mysql.connection.cursor()
    try:
        cur.execute("INSERT INTO individual (firstName, lastName, email, password) VALUES (%s, %s, %s, %s)",
                    (first_name, last_name, email, hashed_pw.decode('utf-8')))
        mysql.connection.commit()
        return jsonify({'message': 'User registered successfully'}), 201
    except Exception as e:
        mysql.connection.rollback()
        return jsonify({'message': f'Error: {str(e)}'}), 500

# Route for getting user profile (protected route)
@app.route('/profile', methods=['GET'])
@token_required
def profile(user):
    return jsonify({'user': {'firstName': user[1], 'lastName': user[2], 'email': user[3]}}), 200

# Route for adding a recipient
@app.route('/add_recipient', methods=['POST'])
def add_recipient():
    data = request.get_json()
    first_name = data.get('firstName')
    last_name = data.get('lastName')
    email = data.get('email')
    blood_type = data.get('bloodType')
    city = data.get('city')

    if not all([first_name, last_name, email, blood_type, city]):
        return jsonify({'message': 'All fields are required'}), 400

    cur = mysql.connection.cursor()
    try:
        cur.execute(
            "INSERT INTO recipient (firstName, lastName, email, blood_type, city) VALUES (%s, %s, %s, %s, %s)",
            (first_name, last_name, email, blood_type, city))
        mysql.connection.commit()
        return jsonify({'message': 'Recipient added successfully'}), 201
    except Exception as e:
        mysql.connection.rollback()
        return jsonify({'message': f'Error: {str(e)}'}), 500

# Route to fetch recipient information by ID or email
@app.route('/recipient_info', methods=['GET'])
def recipient_info():
    # Get the recipient_ID or email from the request arguments
    recipient_id = request.args.get('recipient_ID')
    email = request.args.get('email')

    if not recipient_id and not email:
        return jsonify({'message': 'recipient_ID or email is required'}), 400

    cur = mysql.connection.cursor()
    try:
        # Query based on the provided identifier
        if recipient_id:
            cur.execute(
                "SELECT recipient_ID, firstName, lastName, email, blood_type, city FROM recipient WHERE recipient_ID = %s",
                (recipient_id,)
            )
        elif email:
            cur.execute(
                "SELECT recipient_ID, firstName, lastName, email, blood_type, city FROM recipient WHERE email = %s",
                (email,)
            )

        # Fetch the recipient info
        recipient = cur.fetchone()

        if not recipient:
            return jsonify({'message': 'Recipient not found'}), 404

        # Format the recipient data as JSON
        result = {
            'recipient_ID': recipient[0],
            'firstName': recipient[1],
            'lastName': recipient[2],
            'email': recipient[3],
            'blood_type': recipient[4],
            'city': recipient[5],
        }
        return jsonify({'recipient': result}), 200
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500
    finally:
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

# store the order of blood and recipient
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
        JOIN individual i ON d.donor_ID = i.individual_ID
        WHERE d.donor_ID = %s
        """
        cursor.execute(query, (donor_id,))
        return cursor.fetchone()
    except mysql.connector.Error as err:
        print(f"Error: {err}")

# get recipient info such as blood type
def get_recipient_info(cursor, recipient_id):
    try:
        query = """
        SELECT recipient_ID, firstName, lastName, email, blood_type, city
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
        SELECT branch_ID, name, phoneNumber, city, street
        FROM branch
        WHERE branch_ID = %s
        """
        cursor.execute(query, (branch_id,))
        return cursor.fetchone()
    except mysql.connector.Error as err:
        print(f"Error: {err}")

# create admin user and password
def create_admin_user(cursor, branch_id, email, password):
    try:
        hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        query = """
        INSERT INTO individual (email, password)
        VALUES (%s, %s)
        """
        cursor.execute(query, (email, hashed_password))
        
        # Retrieve the admin's individual ID
        cursor.execute("SELECT LAST_INSERT_ID()")
        admin_id = cursor.fetchone()[0]

        # Link to branch (if needed)
        link_query = """
        INSERT INTO branch_admin (admin_ID, branch_ID)
        VALUES (%s, %s)
        """
        cursor.execute(link_query, (admin_id, branch_id))
        print("Admin user created successfully.")
    except mysql.connector.Error as err:
        print(f"Error: {err}")


    # Route for listing hospitals and Red Cross locations
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
            query = "SELECT branch_ID, name, city, street, phoneNumber FROM branch WHERE name NOT LIKE 'Lebanese Red Cross%'"
        elif location_type == 'R':  # Red Cross branches
            query = "SELECT branch_ID, name, city, street, phoneNumber FROM branch WHERE name LIKE 'Lebanese Red Cross%'"

        # Execute query
        cur.execute(query)
        branches = cur.fetchall()

        # Format results
        result = [
            {
                'id': branch[0],
                'name': branch[1],
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
