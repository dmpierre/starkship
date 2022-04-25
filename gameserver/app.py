from flask import Flask, request
from flask_cors import CORS # allow for cross origin resource sharing
import os
import subprocess
import ast
import json

app = Flask(__name__)
_ = CORS(app)

CUR_DIR = os.getcwd()
PATH_CAIRO_SCRIPTS_FOLDER = f"{CUR_DIR}/../cairo-scripts/"
PATH_MOVES_JSON_FOLDER = f"{CUR_DIR}/../moves/"

# TODO: should this be encapsulated in something? along with ENV variables above
ARGS = [
    "cairo-run", 
    f"--program={PATH_CAIRO_SCRIPTS_FOLDER}/move_compiled.json", 
    f"--program_input={PATH_MOVES_JSON_FOLDER}/move.json", 
    "--layout=small", 
    "--print_output"
]

@app.route("/game", methods=["GET"])
def game():
    return {

    }

@app.route("/mask", methods=["GET"])
def mask():
    return {

    }

@app.route("/reveal")
def reveal():
    return {
        
    }

if __name__ == "__main__":
    app.run()