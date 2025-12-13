# FEATURE SPECIFICATION: VM Control Actions (State Management)

***

## I. Metadata & Status

| Field | Value |
| :--- | :--- |
| **Title** | VM Control: Power, Shutdown, and Reboot |
| **Status** | **READY FOR PLAN** |
| **Owner** | Homelab Operator |
| **Version** | 1.0 |
| **Priority** | Must Have |
| **Dependencies** | VM Status List feature; Host shell execution permissions (PowerShell) |

***

## II. User Story & Functional Requirements (/speckit.specify)

This phase defines the functional scope, use cases, and acceptance criteria—the **"what"** and **"why"** of the build.

### User Story Narrative

**As a** [Homelab Operator]
**I want** [to use clickable dashboard buttons to control the power state of existing virtual machines (Power On, Graceful Shutdown, Reboot, Forceful Power Off)]
**So that** [I can manage the operational status of my virtual environment directly from the dashboard]

### Functional Description

The feature provides four control actions for any VM displayed on the dashboard. The availability of each action must be determined by the VM’s current operational state (Running, Off, Saved). The system must execute the corresponding Hyper-V command securely. All actions must provide immediate feedback to the user and define a time limit for graceful operations.

### Quality Checklist (INVEST Criteria)

The specification confirms readiness for the technical planning phase (/speckit.plan).

| Criterion | Check | Notes |
| :--- | :--- | :--- |
| **Independent (I)** | YES | Focuses on control actions, separate from display logic. |
| **Negotiable (N)** | YES | The specific time-out (TBD) and error codes are negotiable technical details. |
| **Valuable (V)** | YES | Provides necessary operational management capability. |
| **Estimable (E)** | YES | Required inputs, outputs, and constraints are defined. |
| **Small (S)** | YES | Limited to four specific state transition functions. |
| **Testable (T)** | YES | Success and failure modes are defined by Gherkin scenarios. |

***

## III. Technical Requirements & Architectural Plan (/speckit.plan)

This section defines the "how" by translating functional intent into concrete technical contracts, ensuring every assertion is testable,.

### Data Model & System State

This defines the contract for sending commands to the back-end execution service.

```json
{
  "vm_control_request": {
    "vm_uuid": "[Type: GUID/String, REQUIRED]",
    "action": "[Type: String, REQUIRED, valid values: 'start', 'stop_graceful', 'reboot_graceful', 'stop_force']"
  },
  "operational_constraints": {
    "graceful_timeout_seconds": 30,
    "host_script_name": "Control-VMState.ps1"
  }
}
```

### API/Service Interaction (Input/Output Format)

The system will use a back-end service to execute a PowerShell script (`Control-VMState.ps1`) to interact with the Hyper-V host.

| Interface | Input (Required Parameters) | Output (Success/Failure Response) | Citation |
| :--- | :--- | :--- | :--- |
| **[Type, e.g., POST /api/vms/control]** | `vm_control_request` (JSON payload) | **Success (HTTP 202 Accepted):** `{"status": "transitioning", "vm_uuid": "[ID]"}` | |
| **[Type, e.g., ERROR: 409 Conflict]** | [Conditions: VM state does not allow requested action (e.g., trying to start a 'Running' VM)] | `JSON` defining error (e.g., `{"status": "error", "message": "VM is already in state X"}`, HTTP 409) | |
| **[Type, e.g., ERROR: 500 Execution Failure]** | [Conditions: Script execution error or host unreachable] | `JSON` defining error (e.g., `{"status": "error", "message": "Host script execution failed"}`, HTTP 500) | |

***

## IV. Test Scenarios (Confirmation)

This section ensures the desired behavior and edge cases are captured using Gherkin syntax,.

### Scenario: Successfully powering on an 'Off' VM

```gherkin
Given the Hyper-V host is reachable
And VM "Web-Server-01" is currently in the 'Off' state
When the user sends a 'start' action request for "Web-Server-01"
Then the API returns HTTP 202 Accepted
And the VM's status in the dashboard immediately transitions to 'Transitioning'
And the VM eventually reports the 'Running' state
```

### Scenario: Attempting graceful shutdown and successful completion

```gherkin
Given the Hyper-V host is reachable
And VM "DB-Test-02" is currently in the 'Running' state
When the user sends a 'stop_graceful' action request for "DB-Test-02"
Then the API returns HTTP 202 Accepted
And the VM's status transitions to 'Stopping'
And the VM reports the 'Off' state within 30 seconds
```

### Scenario: Failure of graceful shutdown resulting in forceful escalation (Edge Case)

```gherkin
Given the Hyper-V host is reachable
And VM "Unresponsive-03" is currently in the 'Running' state
And a graceful shutdown request is sent
When the VM status remains 'Stopping' after 30 seconds (graceful_timeout_seconds)
Then the system automatically sends a 'stop_force' action request for "Unresponsive-03"
And the VM reports the 'Off' state shortly thereafter
```

### Scenario: Attempting an invalid action (State Conflict)

```gherkin
Given the Hyper-V host is reachable
And VM "Web-Server-01" is currently in the 'Running' state
When the user sends a 'start' action request for "Web-Server-01"
Then the API returns HTTP 409 Conflict
And the dashboard displays an error message: "VM is already running"
And the state of "Web-Server-01" remains 'Running'
```