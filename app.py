import os
import json
import subprocess
import threading
import time
from flask import Flask, render_template, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Global Log Buffer
LOG_BUFFER = []
MAX_LOG_LINES = 1000

def append_log(message):
    global LOG_BUFFER
    timestamp = time.strftime("%H:%M:%S")
    LOG_BUFFER.append(f"[{timestamp}] {message}")
    if len(LOG_BUFFER) > MAX_LOG_LINES:
        LOG_BUFFER.pop(0)

def run_script(script_name):
    """Runs a PowerShell script and streams output to LOG_BUFFER."""
    script_path = os.path.join(os.getcwd(), 'scripts', script_name)
    command = ["powershell", "-ExecutionPolicy", "Bypass", "-File", script_path]
    
    append_log(f"Starting {script_name}...")
    
    try:
        process = subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1
        )
        
        # Read stdout line by line
        for line in process.stdout:
            append_log(line.strip())
            
        # Read stderr
        for line in process.stderr:
            append_log(f"ERROR: {line.strip()}")
            
        process.wait()
        
        if process.returncode == 0:
            append_log(f"Successfully finished {script_name}.")
        else:
            append_log(f"{script_name} failed with exit code {process.returncode}.")
            
    except Exception as e:
        append_log(f"Exception running script: {str(e)}")

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/api/status')
def get_status():
    """Runs Get-LabStatus.ps1 and returns the JSON output."""
    script_path = os.path.join(os.getcwd(), 'scripts', 'Get-LabStatus.ps1')
    try:
        result = subprocess.run(
            ["powershell", "-ExecutionPolicy", "Bypass", "-File", script_path],
            capture_output=True,
            text=True
        )
        if result.returncode != 0:
            return jsonify({"error": "Failed to get status", "details": result.stderr}), 500
        
        # Parse the output
        try:
            status_data = json.loads(result.stdout)
            return jsonify(status_data)
        except json.JSONDecodeError:
             return jsonify({"error": "Invalid JSON from script", "raw": result.stdout}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/provision', methods=['POST'])
def provision_lab():
    global LOG_BUFFER
    LOG_BUFFER = [] # Clear logs on new run
    thread = threading.Thread(target=run_script, args=('Provision-Lab.ps1',))
    thread.start()
    return jsonify({"message": "Provisioning started"}), 202

@app.route('/api/destroy', methods=['POST'])
def destroy_lab():
    global LOG_BUFFER
    LOG_BUFFER = [] # Clear logs on new run
    thread = threading.Thread(target=run_script, args=('Destroy-Lab.ps1',))
    thread.start()
    return jsonify({"message": "Destruction started"}), 202

@app.route('/api/cputemp')
def get_cpu_temp():
    """Runs Get-CpuTemp.ps1 and returns the JSON output."""
    script_path = os.path.join(os.getcwd(), 'scripts', 'Get-CpuTemp.ps1')
    try:
        result = subprocess.run(
            ["powershell", "-ExecutionPolicy", "Bypass", "-File", script_path],
            capture_output=True,
            text=True
        )
        if result.returncode != 0:
             return jsonify({"error": "Failed to get temp", "details": result.stderr}), 500
        
        try:
            data = json.loads(result.stdout)
            return jsonify(data)
        except json.JSONDecodeError:
             return jsonify({"error": "Invalid JSON from script", "raw": result.stdout}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/logs')
def get_logs():
    return jsonify({"logs": LOG_BUFFER})

if __name__ == '__main__':
    print("Starting Antigravity Homelab on http://localhost:5000")
    app.run(host='0.0.0.0', port=5000, debug=True)
