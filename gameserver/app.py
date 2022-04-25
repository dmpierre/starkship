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
SUBMIT_SHOT_PROOF_ARGS = [
    "./submit-reveal-sharp.sh"
]

@app.route("/mask", methods=["GET"])
def mask():
    return {

    }

@app.route("/reveal")
def reveal():
    return {
        
    }


def write_json(obj, path):
    with open(path, "w") as fout:
        json.dump(obj, fout)

@app.route("/submit-shot-proof", methods=["GET"])
def submit_shot_proof():
    shot_location = int(request.args.get("shot-position"))
    ship_location = int(request.args.get("boat-position"))
    shifter_value = int(request.args.get("shifter-value"))
    shot_data = {
            "shot_location": shot_location,
            "ship_location": ship_location,
            "shifter": shifter_value
        }
    write_json(shot_data, "logs/shot_input.json")
    completed_process = subprocess.run(SUBMIT_SHOT_PROOF_ARGS, capture_output=True, text=True)
    return_data = {
        **shot_data,
        "stdout": completed_process.stdout,
        "stderr": completed_process.stderr
    }
    return return_data


@app.route("/get-job-status", methods=["GET"])
def get_job_status():
    jobkey = request.args.get("job-key")

    return {

    }

if __name__ == "__main__":
    app.run()