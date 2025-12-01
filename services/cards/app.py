from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import os
import random

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@localhost:5433/cards')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Card(db.Model):
    __tablename__ = 'cards'
    id = db.Column(db.Integer, primary_key=True)
    card_number = db.Column(db.String(16), unique=True, nullable=False)
    account_id = db.Column(db.Integer, nullable=False)
    card_type = db.Column(db.String(20), default='DEBIT')
    credit_limit = db.Column(db.Float, default=0.0)
    status = db.Column(db.String(20), default='ACTIVE')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'card_number': self.card_number,
            'account_id': self.account_id,
            'card_type': self.card_type,
            'credit_limit': self.credit_limit,
            'status': self.status,
            'created_at': self.created_at.isoformat()
        }

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy', 'service': 'cards'}), 200

@app.route('/api/cards', methods=['GET'])
def get_cards():
    cards = Card.query.all()
    return jsonify([card.to_dict() for card in cards]), 200

@app.route('/api/cards/<int:id>', methods=['GET'])
def get_card(id):
    card = Card.query.get_or_404(id)
    return jsonify(card.to_dict()), 200

@app.route('/api/cards', methods=['POST'])
def create_card():
    data = request.json
    card_number = f"{random.randint(1000, 9999)}{random.randint(1000, 9999)}{random.randint(1000, 9999)}{random.randint(1000, 9999)}"
    card = Card(
        card_number=card_number,
        account_id=data['account_id'],
        card_type=data.get('card_type', 'DEBIT'),
        credit_limit=data.get('credit_limit', 0.0)
    )
    db.session.add(card)
    db.session.commit()
    return jsonify(card.to_dict()), 201

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=8081, debug=True)
