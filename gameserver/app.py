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
MASKER_COMPILED = "masker_compiled.json"
REVEALER_COMPILED = "revealer_compiled.json"
# TODO: should this be encapsulated in something? along with ENV variables above

SUBMIT_SHOT_PROOF_ARGS = [
    "./submit-reveal-sharp.sh"
]

def write_json(obj, path):
    with open(path, "w") as fout:
        json.dump(obj, fout)


MASKER_ARGS = [
    "cairo-run", 
    f"--program={PATH_CAIRO_SCRIPTS_FOLDER}{MASKER_COMPILED}", 
    f"--program_input=./logs/mask_input.json", 
    "--layout=small", 
    "--print_output"
]

REVEALER_ARGS = [
    "cairo-run", 
    f"--program={PATH_CAIRO_SCRIPTS_FOLDER}{REVEALER_COMPILED}", 
    f"--program_input=./logs/reveal_input.json", 
    "--layout=small", 
    "--print_output"
]

MASKER_PROGRAM_HASH = [
    "cairo-hash-program", 
    f"--program={PATH_CAIRO_SCRIPTS_FOLDER}/{MASKER_COMPILED}"
]

REVEALER_PROGRAM_HASH = [
    "cairo-hash-program", 
    f"--program={PATH_CAIRO_SCRIPTS_FOLDER}/{REVEALER_COMPILED}"
]

def parse_stdout(stdout):
    stdout_clean = stdout.replace("Program output:\n ", "").replace("\n", "").split(" ")[1:]
    return stdout_clean[::2]

def parse_stdout2(stdout):
    stdout_clean = stdout.replace("\n", "")
    return stdout_clean

@app.route("/masker_program_hash", methods=["GET"])
def masker_program_hash():
    completed_process = subprocess.run(MASKER_PROGRAM_HASH, capture_output=True, text=True)
    clean_stdout = parse_stdout2(completed_process.stdout)
    return {
        "ouput": completed_process.stdout,
        "stderr": completed_process.stderr,
        "clean_stdout": clean_stdout
    }

@app.route("/revealer_program_hash", methods=["GET"])
def revealer_program_hash():
    completed_process = subprocess.run(REVEALER_PROGRAM_HASH, capture_output=True, text=True)
    clean_stdout = parse_stdout2(completed_process.stdout)
    return {
        "ouput": completed_process.stdout,
        "stderr": completed_process.stderr,
        "clean_stdout": clean_stdout
    }   

@app.route("/mask", methods=["GET"])
def mask():
    ship_loc = request.args.get("ship-location")
    shifter = request.args.get("shifter")
    mask_input = {
        "ship_location": int(ship_loc),
        "shifter": int(shifter)
    }
    _ = write_json(mask_input, "logs/mask_input.json")
    completed_process = subprocess.run(MASKER_ARGS, capture_output=True, text=True)
    clean_stdout = parse_stdout(completed_process.stdout)
    return {
        "output": completed_process.stdout,
        "clean": clean_stdout
    }

@app.route("/reveal", methods=["GET"])
def reveal():
    ship_loc = request.args.get("ship-location")
    shot_loc = request.args.get("shot-location")
    shifter = request.args.get("shifter")
    mask_input = {
        "ship_location": int(ship_loc),
        "shot_location": int(shot_loc),
        "shifter": int(shifter)
    }
    _ = write_json(mask_input, "logs/reveal_input.json")
    completed_process = subprocess.run(REVEALER_ARGS, capture_output=True, text=True)
    clean_stdout = parse_stdout(completed_process.stdout)
    return {
        "output": completed_process.stdout,
        "clean": clean_stdout
    }

@app.route("/submit-shot-proof", methods=["GET"])
def submit_shot_proof():
    shot_location = int(request.args.get("shot-location"))
    ship_location = int(request.args.get("ship-location"))
    shifter_value = int(request.args.get("shifter"))
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