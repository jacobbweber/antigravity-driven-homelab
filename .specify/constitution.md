# Project Constitution

## 1. Core Philosophy
- **Spec-First:** No code is written without a corresponding specification and plan.
- **Idempotency:** All scripts and deployment logic must be idempotent (safe to run multiple times without side effects).
- **Simplicity:** Prefer simple, readable solutions over complex abstractions. "Boring is good."

## 2. Coding Standards
- **Language:** (You will define this in the Spec, but default to Powershell/Bash/Python/Go where appropriate)
- **Comments:** All functions and complex logic blocks must be commented explaining *why*, not just *what*.
- **Error Handling:** Fail loudly and explicitly. No silent failures.

## 3. Documentation
- **README:** Every directory must have a README.md explaining its purpose.
- **Update on Change:** If code changes, comments and documentation *must* be updated in the same commit.

## 4. AI Behavior Rules
- **No Hallucinations:** If you are unsure about a library version or API, check the docs or ask. Do not guess.
- **Step-by-Step:** when implementing, break large tasks into small, verifiable chunks.
- **Context Awareness:** Always read the current `.specify/spec.md` and `.specify/plan.md` before generating code.