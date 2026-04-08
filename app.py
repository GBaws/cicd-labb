from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    return """
    <html>
      <head>
        <title>CI/CD Labb</title>
      </head>
      <body style="text-align:center; font-family:Arial; margin-top:40px;">
        <h1>Hello from CI/CD Labb 🚀</h1>
        <p>Welcome, it is a beautiful day.</p>
        <img src="/static/photo.jpg" alt="Photo" width="400">
      </body>
    </html>
    """

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)