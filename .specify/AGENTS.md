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