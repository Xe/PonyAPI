import os
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Welcome to the Pony API!"

@app.route("/search")
def search():
    return 500, "Not implemented yet"
