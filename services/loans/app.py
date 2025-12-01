from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@localhost:5434/loans')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Loan(db.Model):
    __tablename__ = 'loans'
    id = db.Column(db.Integer, primary_key=True)
    account_id = db.Column(db.Integer, nullable=False)
    loan_type = db.Column(db.String(20), default='PERSONAL')
    amount = db.Column(db.Float, nullable=False)
    interest_rate = db.Column(db.Float, default=5.0)
    term_months = db.Column(db.Integer, default=12)
    status = db.Column(db.String(20), default='PENDING')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'account_id': self.account_id,
            'loan_type': self.loan_type,
            'amount': self.amount,
            'interest_rate': self.interest_rate,
            'term_months': self.term_months,
            'status': self.status,
            'created_at': self.created_at.isoformat()
        }

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy', 'service': 'loans'}), 200

@app.route('/api/loans', methods=['GET'])
def get_loans():
    loans = Loan.query.all()
    return jsonify([loan.to_dict() for loan in loans]), 200

@app.route('/api/loans', methods=['POST'])
def create_loan():
    data = request.json
    loan = Loan(
        account_id=data['account_id'],
        loan_type=data.get('loan_type', 'PERSONAL'),
        amount=data['amount'],
        interest_rate=data.get('interest_rate', 5.0),
        term_months=data.get('term_months', 12)
    )
    db.session.add(loan)
    db.session.commit()
    return jsonify(loan.to_dict()), 201

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=8082, debug=True)
