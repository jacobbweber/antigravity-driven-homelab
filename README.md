# Antigravity Driven Homelab

**Documentation & References:**
- [Gemini Master Guide (Condensed)](docs/gemini-condenced-chat.md)
- [Gemini Raw Chat Logs](docs/gemini-raw-chat.md)
- [Github Spec-Kit](https://github.com/github/spec-kit)

A premium, web-based dashboard for orchestrating a local Hyper-V Homelab, built using **Spec-Driven Development (SDD)**.

## 🚀 The workflow
This project serves as a practical implementation of the Spec-Driven Development methodology, facilitating a collaboration between human intent, AI guidance, and agentic execution.

1.  **The Guide (Gemini Pro 3):** Acts as the SDD teacher, helping define the "What" and "Why". It drafts the initial Specifications and Plans based on high-level goals. Seeing real time examples helped me understand the SDD process better. I can now take this example workflow and add it to NotebookLM as a source along with other SDD sources to learn and study from.
2.  **The Engine (Antigravity IDE):** Acts as the intelligent agent that reads the specs and executes the "How". It writes the code, runs the terminal commands, and validates the implementation in real-time.
3.  **The Platform (You):** Your Windows PC is the substrate. Using Hyper-V, PowerShell, and Python, we build a real infrastructure layer on your local machine.

## 📋 Prerequisites
Ensure your local environment is ready:
- **OS:** Windows 10, 11, or Server (Pro/Enterprise editions required for Hyper-V).
- **Hyper-V:** Enabled in Windows Features.
- **Terminal:** PowerShell 5.1 or PowerShell 7 (run as **Administrator**).
- **Python:** Python 3.x installed and added to PATH.

## 🛠️ Installation & Setup

### 1. Enable Hyper-V
If you haven't already, enable Hyper-V in an Admin PowerShell console:
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```
*Reboot if required.*

### 2. Clone & Prepare
Open this project in **Antigravity IDE** or your terminal of choice.

### 3. Install Python Dependencies
```powershell
pip install -r requirements.txt
```

## 🎮 Usage

### Start the Dashboard
1. Open a PowerShell terminal as **Administrator** (required for Hyper-V commands).
2. Navigate to the project directory.
3. Start the Flask server:
   ```powershell
   python app.py
   ```
4. Open your browser to **[http://localhost:5000](http://localhost:5000)**.

### Using the Lab
- **Spin Up Lab:** Click the rocket button. This triggers the `scripts/Provision-Lab.ps1` script to create a Windows and Linux VM.
- **Monitor:** Watch the "Execution Logs" console in the web UI to see the live PowerShell output.
- **Destroy Lab:** Click the fire button. This triggers `scripts/Destroy-Lab.ps1` to safely shut down and remove the VMs.

## 🏗️ Architecture
- **Frontend:** Vanilla HTML/CSS/JS (Dark Mode, Glassmorphism).
- **Backend:** Python (Flask) acting as a bridge.
- **Infrastructure:** PowerShell scripts interacting directly with the local Hyper-V Module.

---
*Built with Gemini Pro 3 & Antigravity IDE.*
