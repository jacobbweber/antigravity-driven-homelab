Hello\! I am ready to be your expert guide in Spec-Driven Development (SDD). We will take this very slowly, step-by-step, ensuring you understand the "why" and "how" before we write a single line of code for your `antigravity-driven-homelab`.

### What is Spec-Driven Development?

In traditional development, we often just start coding ("vibe coding"). In SDD, we invert this. We write a **Specification** (the "What") and a **Plan** (the "How") *before* we implement.

The **GitHub Spec Kit** automates this by giving you a set of "slash commands" (like `/specify` and `/plan`) to use with your AI assistant. The AI will read your spec and generate the code for you, ensuring it strictly follows your requirements.

-----

### Step 1: Initialize the Toolkit

We need to install the Spec Kit scaffolding into your empty repository. This will create the necessary folders and templates that your AI agent will use to understand your project.

**Instructions:**

1.  Open your terminal inside the `antigravity-driven-homelab` folder.
2.  Run the following command to initialize the toolkit in the current directory (`.`):

<!-- end list -->

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init .
```

*Note: This command uses `uvx`, a fast Python tool runner. If you get a "command not found" error, you may need to install `uv` first (e.g., via `pip install uv` or `brew install uv`).*

3.  **Select your Agent:** The command will ask you which AI assistant you are using (e.g., GitHub Copilot, Claude, Cursor). Use the arrow keys to select the one you have active in your editor.

-----

### Checkpoint 1

**Stop here and report back.**

1.  Did the command run successfully?
2.  Do you see a new folder named `.specify` in your repository?
3.  **Crucial Question:** Which AI assistant did you select (Copilot, Cursor, Claude, etc.)? This determines the exact commands I will give you in the next step.

Once you confirm this, we will write your **Constitution**—the set of laws your project must follow.

... [Up & Running with GitHub Spec Kit \#1](https://www.youtube.com/watch?v=61K-2VRaC6s) ...

This video is the first in a series that walks through the exact setup process we just covered, perfect for following along visually.

http://googleusercontent.com/youtube_content/0

---
This is a fantastic setup. You are on the absolute bleeding edge by combining **Google Antigravity** (the new "Agent-First" IDE) with **GitHub Spec Kit**. This is possibly the most powerful way to build software right now.

Here is the breakdown you asked for, followed by the PowerShell-specific steps.

### 1\. Antigravity vs. GitHub Spec Kit

It is easy to confuse them because both promise "AI that builds software for you," but they play different roles:

  * **Antigravity (The "Engine"):** This is your **IDE** and **Platform**. It provides the *agents* (powered by Gemini 3), the *interface* (Agent Manager), and the *capability* to execute tasks, browse the web, and edit files. It has its own native concept of "planning" (internal artifacts), but it is the tool *doing* the work.
  * **GitHub Spec Kit (The "Manual"):** This is a **Methodology** and **File Structure**. It forces those powerful agents to follow a strict, human-readable process (`Constitution` -\> `Spec` -\> `Plan` -\> `Tasks`).

**Think of it this way:**

  * **Antigravity** is a team of genius engineers sitting in your room.
  * **Spec Kit** is the project manager's clipboard containing the strict Standard Operating Procedures (SOPs) they must follow so they don't go rogue or "vibe code" something you didn't ask for.

By using Spec Kit *inside* Antigravity, you are handing the "Constitution" and "Specs" to the Antigravity agents, effectively supercharging them with clear intent.

-----

### 2\. Initialize Spec Kit (PowerShell Edition)

Since you are in PowerShell, we need to ensure the syntax is clean. We will use `uvx` (part of the `uv` Python toolchain) to run the kit without polluting your global environment.

**Step-by-Step:**

1.  **Check Prerequisites:**
    Ensure you have `uv` installed. Type `uv --version`.

      * *If not installed:* Run this in your PowerShell terminal first:
        ```powershell
        irm https://astral.sh/uv/install.ps1 | iex
        ```
      * *Restart your terminal* if you just installed it.

2.  **Run the Initialization:**
    Execute the following command in your `antigravity-driven-homelab` directory:

    ```powershell
    uvx --from "git+https://github.com/github/spec-kit.git" specify init .
    ```

    *Note: The quotes around the git URL are important in PowerShell to prevent it from misinterpreting the `+` sign.*

3.  **Select Your Agent:**
    When prompted by the CLI, use your arrow keys.

      * Since you are using Antigravity, you likely have access to **Gemini** or a generic **Agent** interface.
      * **Selection Tip:** If "Antigravity" is not explicitly listed yet (the kit is updated frequently), select **Gemini** or **Claude** (whichever model drives your Antigravity instance, likely Gemini 3). This mainly determines which "Slash Commands" text snippet is generated for you to copy-paste later.

-----

### Checkpoint 2

**Stop and report back:**

1.  Did the `uvx` command execute without errors?
2.  Which **Agent** option did you select in the menu? (This is important for the next instruction).
3.  Do you now see a `.specify` hidden folder in your file explorer?

Once you confirm, we will "install" the Spec Kit slash commands into your Antigravity agent's memory.

... [Google Antigravity: Hands on with our new agentic development platform](https://www.youtube.com/watch?v=uzFOhkORVfk) ...

This video is a deep dive into the specific tool you are using, which will help you understand the "Agent Manager" capabilities we will be leveraging with Spec Kit.

http://googleusercontent.com/youtube_content/1

---
No, **`uvx` is not required.** It is just a convenient tool for managing Python scripts. Since you are on Windows, we can use standard Python (`pip`) instead.

However, Spec-Driven Development is about the **methodology**, not the tool. If we can't get the tool installed, we can easily create the folders manually (which actually teaches you the concepts better\!).

Let's try the standard Python way first, and if that doesn't work, we will just create the folder structure ourselves.

### Option A: The Standard Python Way (Try this first)

1.  **Check if you have Python installed.**
    Run this in your PowerShell terminal:

    ```powershell
    python --version
    ```

      * *If you see a version number (like 3.10, 3.12, etc.):* Move to Step 2.
      * *If you see an error:* Skip to **Option B**.

2.  **Install the Spec Kit using pip.**
    Run this command (note the quotes, they are important in PowerShell):

    ```powershell
    pip install "git+https://github.com/github/spec-kit.git"
    ```

3.  **Run the initialization.**
    Once that finishes, try running:

    ```powershell
    specify init .
    ```

-----

### Option B: The "Manual" Mode (Foolproof)

If Option A failed or you don't want to deal with Python installations, we will manually create the scaffolding. This is actually safer because we know exactly what is going into your repo.

**Do this only if Option A failed:**

1.  In your `antigravity-driven-homelab` folder, create a new folder named `.specify`.
    ```powershell
    mkdir .specify
    ```
2.  Inside `.specify`, create a file named `constitution.md`.
    ```powershell
    New-Item -Path .specify/constitution.md -ItemType File
    ```
3.  Inside `.specify`, create another folder named `templates`.
    ```powershell
    mkdir .specify/templates
    ```

### Checkpoint 3

**Report back:**

1.  Did **Option A** (Python/Pip) work, or did you have to switch to **Option B**?
2.  If you used Option B, do you have your empty `constitution.md` file ready?

Once we have the file structure (either via the tool or manually), we will write your **Constitution**. This is the most important step in SDD.
> I had to go with Option B because i kept getting "specify is an unknown command in Windows PowerShell" Even though I installed pip for windows and ran the pop command to install the spec-kit.
---
Great. Manual mode is often better for learning because it demystifies the magic.

Since we are doing this manually, we are technically skipping one step: telling your Antigravity agent *how* to use these files. But we will handle that in a moment. First, let's fill that empty file.

### Step 2: The Constitution

The **Constitution** (`.specify/constitution.md`) is the most critical file in Spec-Driven Development. It is the "Supreme Court" for your project.

Every time your AI agent (Antigravity) writes code or makes a plan, it must check against this file. This prevents the AI from:

  * Switching testing frameworks halfway through.
  * Forgetting to add comments.
  * Using "spaghetti code" instead of your preferred architecture.

**Instructions:**

1.  Open `.specify/constitution.md` in your editor.
2.  Paste the following text into it. This is a "Gold Standard" starter constitution for a Homelab project (focused on reliability and cleanliness).

<!-- end list -->

```markdown
# Project Constitution

## 1. Core Philosophy
- **Spec-First:** No code is written without a corresponding specification and plan.
- **Idempotency:** All scripts and deployment logic must be idempotent (safe to run multiple times without side effects).
- **Simplicity:** Prefer simple, readable solutions over complex abstractions. "Boring is good."

## 2. Coding Standards
- **Language:** (You will define this in the Spec, but default to Python/Go/Bash where appropriate)
- **Comments:** All functions and complex logic blocks must be commented explaining *why*, not just *what*.
- **Error Handling:** Fail loudly and explicitly. No silent failures.

## 3. Documentation
- **README:** Every directory must have a README.md explaining its purpose.
- **Update on Change:** If code changes, comments and documentation *must* be updated in the same commit.

## 4. AI Behavior Rules
- **No Hallucinations:** If you are unsure about a library version or API, check the docs or ask. Do not guess.
- **Step-by-Step:** when implementing, break large tasks into small, verifiable chunks.
- **Context Awareness:** Always read the current `.specify/spec.md` and `.specify/plan.md` before generating code.
```

3.  **Save the file.**

-----

### Step 3: The Missing "Slash Commands"

Since we didn't run the installer, your Antigravity agent doesn't know what "SDD" is yet. We need to give it a "System Prompt" so it understands how to behave.

**Instructions:**

1.  Create a new file in the **root** of your repository (not inside `.specify`) called `AGENTS.md`.
2.  Paste the following "Agent Instructions" into it. This maps the SDD commands to actual actions the AI should take.

<!-- end list -->

```markdown
# Agent Instructions for Antigravity

You are an expert software engineer following Spec-Driven Development (SDD).

## Your Interaction Protocol
When I give you a command, you must follow the specific workflow below.

### 1. /speckit.constitution
- **Action:** Read `.specify/constitution.md`.
- **Goal:** Internalize the project's governing laws.
- **Output:** Confirm you have read and understood the principles.

### 2. /speckit.specify
- **Action:** Read the user's prompt and draft a requirements file at `.specify/spec.md`.
- **Goal:** define the "What" and "Why".
- **Rules:** - Focus on user stories and requirements.
    - Do NOT discuss technical implementation details (libraries, databases) yet.
    - adhere to the Constitution.

### 3. /speckit.plan
- **Action:** Read `.specify/spec.md` and create a technical plan at `.specify/plan.md`.
- **Goal:** Define the "How".
- **Rules:**
    - Choose the tech stack.
    - Define file structure.
    - Verify that the plan meets the requirements in the Spec.

### 4. /speckit.implement
- **Action:** Read `.specify/plan.md` and generate the actual code files.
- **Goal:** Build the software.
- **Rules:**
    - Create the files exactly as planned.
    - Update `.specify/checklist.md` as you complete tasks.
```

3.  **Save the file.**

-----

### Checkpoint 4

**Report back:**

1.  Do you have `constitution.md` populated?
2.  Do you have `AGENTS.md` populated?

Once you confirm, we are going to "Prime the Agent" (load these rules into Antigravity) and then write our first **Spec**.

---

Excellent. Now we are ready to wake up the machine.

You have the rules (Constitution) and the instruction manual (AGENTS.md) sitting in your files, but your Antigravity agent hasn't read them yet. We need to "prime" the agent so it adopts the Spec-Driven Development persona.

### Step 4: Prime the Agent

1.  Open the **Chat / Agent Interface** in Antigravity.
2.  Paste the following prompt exactly:

    > Please read the file `AGENTS.md` to understand your new operating protocols. Then, read `.specify/constitution.md` to understand the project rules. Confirm when you have internalized these instructions and are ready to receive Spec-Driven Development commands.

3.  **Wait for the Agent's response.** It should say something like "I have read the files and I am ready."

---

### Step 5: The First Command (`/speckit.constitution`)

Even though the agent *just* read the constitution, in SDD we are explicit. We formally "invoke" the constitution to make sure it is top-of-mind for the session.

1.  In the chat, type:
    > /speckit.constitution

2.  **The Agent should:** Quote or summarize your constitution back to you, confirming it will follow the rules (like "Idempotency" and "Simplicity").

---

### Step 6: The Specification (`/speckit.specify`)

Now we start the real work. You mentioned you want a **Web Front-end** that interacts with **Hyper-V** and PowerShell to create a homelab. We need to define *what* that looks like, without worrying about *how* to code it yet.

1.  In the chat, copy and paste this command:

    > /speckit.specify
    >
    > **Project:** Antigravity Driven Homelab
    >
    > **Goal:** Build a simple web-based dashboard that allows me to provision and manage a local Homelab on my Windows PC.
    >
    > **Key Features:**
    > 1. **Web UI:** A clean interface to see status of VMs.
    > 2. **Backend:** Must use PowerShell scripts to interact with Hyper-V.
    > 3. **Provisioning:** A button to "Spin up Lab" which creates a Windows VM and a Linux VM automatically.
    > 4. **Transparency:** The UI should show logs of what PowerShell is doing in the background.
    >
    > **User Story:**
    > "As a learner, I want to click one button to deploy a fresh environment so I can practice without breaking my main PC."

2.  **What will happen:** The Agent will read this and generate a file called `.specify/spec.md`. It might ask you clarifying questions.

---

### Checkpoint 5

**Report back:**
1.  Did the agent successfully read `AGENTS.md`?
2.  Did the agent generate the `.specify/spec.md` file?
3.  **Open that file.** Does it look right to you? (It should be a text description of your homelab).

Once the Spec is created, we will move to the **Plan** phase.

---

Perfect. This means the "Brain" (Antigravity) understands the "Dream" (Spec). Now we need to determine the **Architecture** (Plan).

### Step 7: The Plan (`/speckit.plan`)

This is where your project succeeds or fails. If we just told the AI to "code it" now, it might pick a complex framework you don't know (like React with Redux) or a language that doesn't run well on your machine.

We need to constrain the AI to use tools that are easy for you to maintain. Since you are learning and want to keep it simple ("Simplicity" is in your Constitution!), I recommend a stack that uses **Python** for the web server (backend) to call your **PowerShell** scripts.

**Instructions:**

1.  In the Antigravity chat, paste the following command. Note how we are being specific about the "Stack":

    > /speckit.plan
    >
    > **Tech Stack Requirements:**
    > - **Backend:** Python (using the lightweight **Flask** framework). It is easy to read and works great for running shell commands.
    > - **Frontend:** Simple HTML + JavaScript (No complex build steps like npm/webpack. Keep it "Vanilla").
    > - **Integration:** The Python backend will use the `subprocess` module to trigger PowerShell scripts.
    > - **Database:** None needed yet (or a simple JSON file/SQLite) to track VM status.
    >
    > **Output:** Create a file `.specify/plan.md` that lists every file we need to create and the logic flow.

2.  **What will happen:** The Agent will read your `spec.md` (the goal) and combine it with these new constraints to write a detailed technical checklist in `.specify/plan.md`.

---

### Step 8: Review the Plan

**This is the most dangerous part of SDD.** The AI might hallucinate a file structure that is too complicated. You must review the `plan.md` file before we let it write code.

**Open `.specify/plan.md` and check for these 3 things:**

1.  **File Structure:** Does it list specific filenames? (e.g., `app.py`, `templates/index.html`, `scripts/deploy_vm.ps1`)?
2.  **Logic:** Does it explain *how* the Python web server will talk to PowerShell?
3.  **Complexity:** Does it look scary? If it mentions "React", "Docker", or "PostgreSQL", it violated our "Simplicity" rule.

---

### Checkpoint 6

**Report back:**
1.  Did the agent create `.specify/plan.md`?
2.  **Paste the list of files** the agent is proposing to build here. I want to double-check them for you before we give the "Green Light" to code.
---

That plan is **perfect**.

It respects your "Simplicity" rule by avoiding complex frontend frameworks, and it keeps the logic where you want it: in PowerShell.

  * **Why this works:** `app.py` acts as a traffic cop. You click a button in the browser -\> Python catches the click -\> Python tells PowerShell to "do the heavy lifting" -\> PowerShell talks to Hyper-V -\> Python reports back "Done".

You are now ready for the final step of the SDD loop: **Implementation**.

### Step 9: The Build (`/speckit.implement`)

This is the moment of truth. We are going to tell the agent to read that plan and write the actual code files.

**Instructions:**

1.  In the Antigravity chat, type:

    > /speckit.implement

2.  **Watch the magic:** You should see files appearing in your file explorer.

      * `app.py`
      * `templates/index.html`
      * `scripts/` folder (hopefully with a placeholder script)

-----

### Step 10: The First Run

Once the agent confirms "Implementation Complete," we need to see if it actually works. Since we are using Python/Flask, we need to install the library and run it.

**Do this after the agent finishes:**

1.  **Install Flask:**
    In your PowerShell terminal:

    ```powershell
    pip install flask
    ```

2.  **Run the App:**

    ```powershell
    python app.py
    ```

3.  **Check the Browser:**
    You should see a message in the terminal saying `Running on http://127.0.0.1:5000`. Open that link in your web browser.

-----

### Checkpoint 7

**Report back:**

1.  Did the code generation finish successfully?
2.  Were you able to run `python app.py` and see the website in your browser? (It might be empty or simple right now, that's okay).
3.  **Crucial Check:** Does the website have a button/interface? (Don't click it yet, just verify it exists).

---

This is a classic "AI Development" moment\!

**What happened:** The AI, trying to be helpful and follow "Best Practices," added a library called `Flask-CORS` (Cross-Origin Resource Sharing) to your `app.py`. This is a security feature to ensure your web browser allows the frontend to talk to the backend. However, it didn't tell us to install it first.

We need to install that missing piece.

### Step 1: Fix the Missing Dependency

Run this command in your PowerShell terminal:

```powershell
pip install flask-cors
```

### Step 2: Try Running the App Again

Once that installs successfully, run the app again:

```powershell
python app.py
```

### Checkpoint 8

**Report back:**

1.  Did the error go away?
2.  Do you see a line that says `Running on http://127.0.0.1:5000`?
3.  **If yes:** Open that link in your browser. Do you see your "Antigravity Driven Homelab" dashboard?
---

This is a **huge win**! 🎉

You have just successfully completed your first **Spec-Driven Development Cycle**.

Let's take a deep breath and look at what you achieved in just a few minutes:
1.  **Defined the Rules** (Constitution) -> The "Laws" your AI must obey.
2.  **Defined the Goal** (Spec) -> The "What".
3.  **Defined the Architecture** (Plan) -> The "How".
4.  **Generated Code** (Implement) -> The Execution.
5.  **Debugged** -> The Reality of software dev (fixing that missing `flask-cors`).

Most people just ask an AI "Make me a homelab app," get a wall of broken code, and give up. You built a structured, maintainable foundation.

---

### Step 11: Inspect the "Engine" (PowerShell)

Before we click any buttons on that web page (which might error out if Hyper-V isn't ready), we need to look at the PowerShell script the agent created.

Since you want to learn, this is the most important part: **Did the AI write good PowerShell?**

1.  Go to your file explorer in VS Code / Antigravity.
2.  Open the `scripts` folder.
3.  You should see a `.ps1` file (likely named `provision_vm.ps1`, `deploy.ps1`, or similar). **Open it.**

### Checkpoint 9

**Copy and paste the contents of that PowerShell script here.**

I want to review it with you to see:
1.  Is it safe to run?
2.  Did it actually put in Hyper-V commands, or just "placeholder" comments? (AI often puts placeholders like `# Add logic here` first).

Once we see what's in there, we will know if we need to do another "Spec Cycle" to flesh out the script.

---

This is a **textbook Spec-Driven Development script**.

I want to point out exactly *why* this script is a success, referring back to the **Constitution** you wrote earlier.

### Code Review: The "Constitution" Check

  * **Rule 1: Idempotency:** Look at the line `if (Get-VM -Name $vmName ...)`.
      * The script checks if the VM exists *before* trying to create it. You can run this script 100 times, and it won't crash or create duplicate VMs. It just says "Skipping creation." The AI followed your rules perfectly\!
  * **Rule 2: Simplicity:** It uses standard commands (`New-VM`, `Start-VM`) without complex wrapper functions.
  * **Rule 3: Error Handling:** It has a `try { ... } catch { ... }` block to report failures gracefully.

### The "Empty Shell" Reality

There is one important detail: **These VMs are empty.**

> `# For this demo, we leave it as a shell VM.`

The AI did exactly what we asked for in the Spec ("Build a lab... create a VM"), but since we didn't specify *"Install Windows Server 2022 from an ISO,"* it took the simplest path: creating "Shell VMs" (virtual hardware with no hard drive and no operating system).

This is actually good\! In SDD, we iterate. First, we prove we can create the hardware. *Then* we write a spec to install the OS.

-----

### Step 12: Manual Verification (The "Smoke Test")

Before we trust the Web UI to run this, we need to run it manually in PowerShell to ensure your computer allows it. **Hyper-V commands require Administrator privileges.**

**Instructions:**

1.  **Open a NEW PowerShell terminal as Administrator.** (Right-click PowerShell -\> Run as Administrator).
2.  Navigate to your script folder:
    ```powershell
    cd D:\Tech\git\my_projects\antigravity-driven-homelab\scripts
    ```
3.  Run the script:
    ```powershell
    .\Provision-Lab.ps1
    ```

**Possible Errors:**

  * *Error: "New-VM is not recognized..."* -\> This means Hyper-V is not installed or enabled on your Windows machine.
  * *Error: "Virtual Switch 'Default Switch' could not be found..."* -\> We might need to check your switch names.

-----

### Checkpoint 10

**Report back:**

1.  Did the script run successfully in the Admin terminal?
2.  **Open "Hyper-V Manager"** on your PC. Do you see two new VMs named `AG-Lab-Win` and `AG-Lab-Linux`?
3.  (If they are there) Start one. It should turn on but probably say "Boot Failed" (because it has no hard drive). **This is expected and counts as a success.**

Once we confirm the script works, we will go back to your Web UI and press the button to see the full "End-to-End" magic\!

---
This is excellent. You have confirmed that the "Engine" (PowerShell + Hyper-V) is solid.

Now we face the final boss of this level: **Permissions.**

Because your PowerShell script requires Administrator rights to touch Hyper-V, your Python Web App **also** needs Administrator rights to run that script. If you run `python app.py` from a normal terminal, the button on the website will click, but nothing will happen (or it will crash) because it won't have permission to create VMs.

### Step 13: The "End-to-End" Integration Test

We need to run the Web Server from your **Administrator** terminal to give it the power it needs.

**Instructions:**

1.  **Stop the old server:** Go to the terminal where you first ran `python app.py` (the one that might still be running). Press `Ctrl+C` to stop it.
2.  **Switch to your Admin Terminal:** Go back to that elevated PowerShell window where you just successfully ran the script.
3.  **Navigate to the root:** You are currently in the `scripts` folder. Go up one level:
    ```powershell
    cd ..
    ```
4.  **Run the App as Admin:**
    ```powershell
    python app.py
    ```
5.  **The Moment of Truth:**
      * Open your browser to `http://127.0.0.1:5000`.
      * **Click the "Provision Lab" button.**
      * *Watch the terminal window:* You should see Python printing out the logs (Checking AG-Lab-Win... Skipping creation...).
      * *Watch the Web UI:* Ideally, the logs or a "Success" message should appear on the screen.

-----

### Checkpoint 11

**Report back:**

1.  Did clicking the button work without crashing the server?
2.  Did the Web UI show you the output (logs), or did you only see it in the terminal?
      * *Note:* It is common for the first version of the UI to just say "Done" without showing the live logs. We can fix that in the next "Spec Cycle" if needed.
3.  **Summary:** Do you now have a web page that controls your Hyper-V?

If this works, you have officially built a "Full Stack Agentic Homelab" platform\! The next step will be deleting these empty VMs and creating *real* ones.

---
This is the "Checkpoint of Victory." 🏆

You have successfully used Spec-Driven Development to build a functional Full-Stack application that controls infrastructure. That is a massive achievement for a first run.

Now you have encountered the next phase of software development: **The Missing Feature.**

The AI likely created the "Destroy" button in the HTML (because it knows a "Provision" button usually needs a counterpart), but it marked it as disabled or restricted because we never explicitly asked for a destruction logic in our Spec. In SDD, we don't just "hack the code" to fix this. We go back to the source.

We are going to perform your first **Iteration Cycle**.

---

### Step 14: Update the Spec (`/speckit.specify`)

We need to tell the system that we *want* the ability to destroy the lab. We do this by updating the `spec.md` file.

**Instructions:**

1.  Open `.specify/spec.md` in your editor.
2.  Add a new item to the "Key Features" or "User Stories" section. Add this line:
    > **Feature 5: Destruction.** A "Destroy Lab" button that forcefully removes the VMs (`AG-Lab-Win` and `AG-Lab-Linux`) to clean up resources. It must be enabled in the UI.
3.  **Save the file.**

4.  **Run the update command.** In your Antigravity Chat, type:
    > /speckit.specify
    >
    > **Update:** I have modified `.specify/spec.md` to include a "Destroy" feature. Please review the changes and confirm you understand the new requirement.

---

### Step 15: Update the Plan (`/speckit.plan`)

Now the Agent knows *what* you want (Destruction), but it needs to plan *how* to do it safely (Idempotency).

1.  In the Chat, type:
    > /speckit.plan
    >
    > **Task:** We need to implement the "Destroy Lab" functionality.
    > 1. Create a new PowerShell script `destroy_lab.ps1`.
    > 2. Update `app.py` to add a `/destroy` route.
    > 3. Update `index.html` to enable the button and link it to the new route.
    > 4. Ensure the PowerShell script checks if VMs exist before trying to delete them (Idempotency!).

2.  **Wait for the Agent.** It will generate an updated Plan. **Read it carefully.** Ensure it mentions `Remove-VM` command for PowerShell.

---

### Step 16: Implement (`/speckit.implement`)

Once the plan looks good (it should look very similar to the provisioning plan, just in reverse), give the green light.

1.  In the Chat, type:
    > /speckit.implement

2.  **Watch the files.** You should see:
    * `scripts/destroy_lab.ps1` appear.
    * `app.py` get modified.
    * `templates/index.html` get modified.

---

### Checkpoint 12

**Report back:**
1.  Did the Agent create the `destroy_lab.ps1` script?
2.  **Restart your Flask Server** (Ctrl+C, then `python app.py` as Admin).
3.  Refresh the webpage. Is the "Destroy Lab" button now clickable (not restricted)?
4.  **Click it.** Do your VMs disappear from Hyper-V?

If this works, you have officially mastered the **SDD Loop**: `Spec -> Plan -> Implement -> Verify`. You are now an SDD practitioner.

---

That is fantastic news\! 🚀 You have officially closed the loop.

You didn't just "write some code"; you engineered a system using the **Spec-Driven Development** methodology.

### The "Victory Lap" Recap

Let's look at the cycle you just mastered. It is a powerful mental model you can use for the rest of your career:

1.  **Constitution:** You established the laws (Simplicity, Idempotency).
2.  **Spec:** You defined the behavior ("I want a destroy button").
3.  **Plan:** You mapped out the change (HTML button -\> Python Route -\> PowerShell Script).
4.  **Implement:** The Agent wrote the code.
5.  **Verify:** You tested it (and it worked\!).

Most developers skip steps 1-3 and jump straight to coding, which is why they end up with "spaghetti code." You now have a clean, documented, and scalable foundation.

-----

### What's Next? (Level 2: Parameterization)

Right now, your lab is "hard-coded." It always creates the same VMs with the same names and memory.

To really learn SDD, we need to handle **complexity**. The next logical step is to let the *User* decide what the lab looks like from the web page.

**The Challenge:**
Modify the system so you can type "4GB" or "Test-VM" into the website, and have that specific configuration passed all the way down to Hyper-V.

**Are you ready for Level 2?**

If so, your next step is to **Commit your current success** (so we can't break it) and then **Update the Spec**.

1.  **Commit to Git:**

    ```powershell
    git add .
    git commit -m "feat: Functional V1 with Provision and Destroy"
    ```

2.  **Then, tell me when you are ready**, and I will walk you through the "Parameterization Cycle" where we connect HTML Forms -\> Python variables -\> PowerShell arguments.

---


