from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import os
import random

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'postgres://postgres:postgres@localhost:5432/accounts')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Account(db.Model):
    __tablename__ = 'accounts'
    id = db.Column(db.Integer, primary_key=True)
    account_number = db.Column(db.String(10), unique=True, nullable=False)
    customer_name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100))
    phone = db.Column(db.String(15))
    account_type = db.Column(db.String(20), default='savings')
    balance = db.Column(db.Float, default=0.0)
    status = db.Column(db.String(20), default='active')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'account_number': self.account_number,
            'customer_name': self.customer_name,
            'email': self.email,
            'phone': self.phone,
            'account_type': self.account_type,
            'balance': self.balance,
            'status': self.status,
            'created_at': self.created_at.isoformat()
        }

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy', 'service': 'accounts'}), 200

@app.route('/api/accounts', methods=['GET'])
def get_accounts():
    accounts = Account.query.all()
    return jsonify([account.to_dict() for account in accounts]), 200

@app.route('/api/accounts/<int:id>', methods=['GET'])
def get_account(id):
    account = Account.query.get_or_404(id)
    return jsonify(account.to_dict()), 200

@app.route('/api/accounts', methods=['POST'])
def create_account():
    data = request.get_json()
    account_number = f"ACCT{random.randint(100000, 999999)}"
    account = Account(
        account_number=account_number,
        customer_name=data.get('customer_name'),
        email=data.get('email'),
        phone=data.get('phone'),
        account_type=data.get('account_type', 'savings'),
        balance=data.get('balance', 0.0)
    )

    db.session.add(account)
    db.session.commit()
    return jsonify(account.to_dict()), 201

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        app.run(debug=True, host='0.0.0.0', port=8080)
        print("Accounts service is running on port 8080")