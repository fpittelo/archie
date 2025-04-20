from flask import Flask, request, jsonify
from flask_oidc import OpenIDConnect
import requests

app = Flask(__name__)

# OIDC Configuration
app.config.update({
    "SECRET_KEY": "your_secret_key",  # Replace with a secure secret key
    "OIDC_CLIENT_SECRETS": "client_secrets.json",  # Path to your OIDC client secrets file
    "OIDC_RESOURCE_SERVER_ONLY": True,
    "OIDC_INTROSPECTION_AUTH_METHOD": "client_secret_post",
    "OIDC_TOKEN_TYPE_HINT": "access_token",
    "OIDC_SCOPES": ["openid", "profile", "email"],
})

oidc = OpenIDConnect(app)

# OpenAI API Key (replace with your actual key)
OPENAI_API_KEY = "your_openai_api_key"

@app.route("/api/query", methods=["POST"])
@oidc.accept_token(require_token=True)  # Protect this endpoint with OIDC
def query():
    data = request.json
    user_query = data.get("query")

    if not user_query:
        return jsonify({"error": "Query is required"}), 400

    # Interact with OpenAI API
    try:
        openai_response = requests.post(
            "https://api.openai.com/v1/completions",
            headers={"Authorization": f"Bearer {OPENAI_API_KEY}"},
            json={
                "model": "text-davinci-003",
                "prompt": user_query,
                "max_tokens": 100,
            },
        )
        openai_response.raise_for_status()
        result = openai_response.json()
        return jsonify({"query": user_query, "response": result["choices"][0]["text"]})
    except Exception as e:
        return jsonify({"error": f"Failed to query OpenAI API: {str(e)}"}), 500

@app.route("/api/logout", methods=["POST"])
@oidc.accept_token(require_token=True)  # Protect this endpoint with OIDC
def logout():
    try:
        oidc.logout()
        return jsonify({"message": "Logged out successfully"}), 200
    except Exception as e:
        return jsonify({"error": f"Failed to log out: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
