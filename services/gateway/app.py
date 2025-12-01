from flask import Flask, request, jsonify
import requests
import os

app = Flask(__name__)

ACCOUNTS_URL = os.getenv('ACCOUNTS_SERVICE_URL', 'http://localhost:8080')
CARDS_URL = os.getenv('CARDS_SERVICE_URL', 'http://localhost:8081')
LOANS_URL = os.getenv('LOANS_SERVICE_URL', 'http://localhost:8082')

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy', 'service': 'gateway'}), 200

@app.route('/api/accounts', defaults={'path': ''}, methods=['GET', 'POST'])
@app.route('/api/accounts/<path:path>', methods=['GET', 'POST', 'PUT', 'DELETE'])
def proxy_accounts(path):
    url = f"{ACCOUNTS_URL}/api/accounts/{path}" if path else f"{ACCOUNTS_URL}/api/accounts"
    return proxy_request(url)

@app.route('/api/cards', defaults={'path': ''}, methods=['GET', 'POST'])
@app.route('/api/cards/<path:path>', methods=['GET', 'POST', 'PUT', 'DELETE'])
def proxy_cards(path):
    url = f"{CARDS_URL}/api/cards/{path}" if path else f"{CARDS_URL}/api/cards"
    return proxy_request(url)

@app.route('/api/loans', defaults={'path': ''}, methods=['GET', 'POST'])
@app.route('/api/loans/<path:path>', methods=['GET', 'POST', 'PUT', 'DELETE'])
def proxy_loans(path):
    url = f"{LOANS_URL}/api/loans/{path}" if path else f"{LOANS_URL}/api/loans"
    return proxy_request(url)

def proxy_request(url):
    try:
        resp = requests.request(
            method=request.method,
            url=url,
            headers={k:v for k,v in request.headers if k != 'Host'},
            data=request.get_data(),
            cookies=request.cookies,
            allow_redirects=False
        )
        return resp.content, resp.status_code, resp.headers.items()
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8090, debug=True)
