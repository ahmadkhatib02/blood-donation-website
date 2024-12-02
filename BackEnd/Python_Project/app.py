from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS
import bcrypt
from functools import wraps
app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing (optional for frontend-backend separation)

# Configuring MySQL database
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'  # Change to your MySQL username
app.config['MYSQL_PASSWORD'] = 'MYSQLmabelle05!'  # Change to your MySQL password
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

    if not first_name or not last_name or not email or not password:
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

# Route for adding a blood sample test
@app.route('/add_test', methods=['POST'])
@token_required
def add_test(user):
    data = request.get_json()
    sobriety = data.get('sobriety')
    last_donated_date = data.get('last_donated_date')
    disease = data.get('disease')
    BMI = data.get('BMI')
    hemoglobin = data.get('hemoglobin')
    iron_levels = data.get('iron_levels')

    cur = mysql.connection.cursor()
    try:
        cur.execute("INSERT INTO blood_sample_test (sobriety, last_donated_date, disease, BMI, hemoglobin, iron_levels) VALUES (%s, %s, %s, %s, %s, %s)",
                    (sobriety, last_donated_date, disease, BMI, hemoglobin, iron_levels))
        mysql.connection.commit()
        return jsonify({'message': 'Test added successfully'}), 201
    except Exception as e:
        mysql.connection.rollback()
        return jsonify({'message': f'Error: {str(e)}'}), 500

# Route for listing all branches
@app.route('/branches', methods=['GET'])
def branches():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM branch")
    branches = cur.fetchall()
    return jsonify({'branches': branches}), 200

# Route for listing all available blood units
@app.route('/blood_units', methods=['GET'])
def blood_units():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM blood_unit_tobedonated")
    blood_units = cur.fetchall()
    return jsonify({'blood_units': blood_units}), 200

# Route for listing donors
@app.route('/donors', methods=['GET'])
def donors():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM donor")
    donors = cur.fetchall()
    return jsonify({'donors': donors}), 200


    # Route for listing hospitals and Red Cross locations
@app.route('/locations', methods=['GET'])
def locations():
    location_type = request.args.get('type')  # Get the type (H for hospitals, R for Red Cross) from the query parameter

    if not location_type or location_type not in ['H', 'R']:
        return jsonify({'message': 'Invalid or missing location type'}), 400

    cur = mysql.connection.cursor()
    try:
        # Query the database for locations based on type
        cur.execute("SELECT * FROM location WHERE type = %s", (location_type,))
        locations = cur.fetchall()

        # Convert the result into a readable format
        result = [
            {
                'id': loc[0],
                'name': loc[1],
                'address': loc[2],
                'phone': loc[3],
                'type': loc[4]  # H for hospitals, R for Red Cross
            }
            for loc in locations
        ]

        return jsonify({'locations': result}), 200
    except Exception as e:
        return jsonify({'message': f'Error: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(debug=True)
