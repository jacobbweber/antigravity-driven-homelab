# Specification: Antigravity Driven Homelab

## 1. Goal
Build a simple, web-based dashboard that allows the user to provision and manage a local Homelab on their Windows PC. The system aims to provide a safe, one-click environment for learning and practice.

## 2. Context
The user wants to practice IT skills without risking their main PC. They need an abstraction layer over raw Hyper-V checks and PowerShell scripts that makes spinning up and tearing down environments effortless and transparent.

## 3. User Stories
- **Story 1:** As a learner, I want to view a web dashboard that shows the status of my Homelab VMs (Running, Stopped, Non-existent).
- **Story 2:** As a learner, I want to click a "Spin up Lab" button to automatically provision a Windows VM and a Linux VM.
- **Story 3:** As a learner, I want to see real-time logs of the PowerShell commands executing in the background so I understand what is happening (transparency).
- **Story 4:** As a user, I want a clean, modern interface (as per Antigravity design aesthetics) to interact with my lab.

## 4. Requirements
### 4.1. Web UI (Frontend)
- **Framework:** Simple HTML/JS or a lightweight framework (e.g., Vue/React via CDN or buildless) – *To be defined in Plan, but must match Antigravity aesthetics (premium, dark mode).*
- **Views:**
    - **Dashboard:** VM Cards (Windows Node, Linux Node) with status indicators.
    - **Controls:** Global "Spin Up", "Tear Down" buttons. Individual VM actions (Start/Stop).
    - **Log Console:** A scrolling terminal-like window showing backend execution output.

### 4.2. Backend (API & Logic)
- **Tech Stack:** Simple HTTP Server enabling PowerShell execution. (Potentially Python `http.server` with CGI, or a lightweight Node.js/Go wrapper that calls PS scripts).
- **Hyper-V Interaction:**
    - **Language:** PowerShell.
    - **Core Scripts:**
        - `Get-LabStatus.ps1`: Returns JSON object of VMs and statuses.
        - `Provision-Lab.ps1`: creating VMs, VHDX handling, networking.
        - `Destroy-Lab.ps1`: safely removing VMs and cleanup.

### 4.3. Provisioning Logic
- **Windows VM:** Standard config.
- **Linux VM:** Standard config (likely Ubuntu or Alpine).
- **Network:** Ensure VMs are on a private or internal Hyper-V switch to isolate from main network if needed, or Default Switch for internet access.

## 5. Non-Functional Requirements
- **OS:** Windows 10/11 with Hyper-V enabled.
- **Project Structure:** Clear separation of Frontend (UI) and Backend (Scripts).
- **Aesthetics:** "Wowed at first glance" - vibrant colors, glassmorphism, smooth animations.
