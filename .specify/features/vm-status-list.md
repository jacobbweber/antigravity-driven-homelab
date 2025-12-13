# FEATURE SPECIFICATION: Hyper-V VM Status Dashboard List

***

## I. Metadata & Status

| Field | Value |
| :--- | :--- |
| **Title** | Hyper-V VM Status Dashboard List |
| **Status** | **READY FOR PLAN** |
| **Owner** | Homelab Operator |
| **Version** | 1.0 |
| **Priority** | Must Have |
| **Dependencies** | Execution access to Hyper-V host via PowerShell |

***

## II. User Story & Functional Requirements (/speckit.specify)

This phase defines the functional scope, focusing on the **"what"** and **"why"** of the build, which Spec-Driven Development mandates be explicit and rigorous.

### User Story Narrative

**As a** [Homelab Learner]
**I want** [to view a real-time list of all local Hyper-V virtual machines, including their name, unique ID, and operational state]
**So that** [I can monitor the status of my virtual environment from a single web interface and quickly detect operational changes]

### Functional Description

The feature must securely retrieve the current state of all VMs on the host. The list must display the VM's `Name` and its mapped operational status, categorized as `Running`, `Off`, or `Saved`. The presentation should be a list format on the dashboard.

### Quality Checklist (INVEST Criteria)

The specification confirms readiness, ensuring the story is robust enough to proceed to the architectural blueprint phase.

| Criterion | Check | Notes |
| :--- | :--- | :--- |
| **Independent (I)** | YES | Focus is solely on data retrieval and rendering, limiting dependencies. |
| **Negotiable (N)** | YES | UI layout and implementation details remain flexible. |
| **Valuable (V)** | YES | Provides necessary operational monitoring value. |
| **Estimable (E)** | YES | Necessary properties and output format are defined. |
| **Small (S)** | YES | Confined to a single data fetch and list display component. |
| **Testable (T)** | YES | Success is validated against the required JSON output and displayed state mapping. |

***

## III. Technical Requirements & Architectural Plan (/speckit.plan)

This section details the **"how,"** establishing the technical design and data contracts required by the AI agent to generate compliant code,.

### Data Model & System State

The implementation must use the following JSON structure to represent each virtual machine item.

```json
{
  "vm_list_item": {
    "display_name": "[Type: String]",
    "vm_uuid": "[Type: GUID/String]",
    "hyperv_raw_state": "[Type: String (e.g., 'Running', 'Paused', 'Stopped')]",
    "dashboard_status": "[Type: String ('Running', 'Off', 'Saved')]",
    "uptime_seconds": "[Type: Integer, null if Off]"
  }
}
```

### API/Service Interaction (Input/Output Format)

The system is constrained to retrieve VM data by executing a designated PowerShell script that returns a structured JSON array.

| Interface | Input (Required Parameters) | Output (Success/Failure Response) |
| :--- | :--- | :--- |
| **Internal Service Call (PowerShell Script Execution)** | Script Name: `Get-LabStatus.ps1` (Execution via system shell) | **Success (HTTP 200 equivalent):** `JSON` array of `vm_list_item` objects |
| **[Type, e.g., ERROR: 500 Script Execution Failure]** | [Conditions: PowerShell environment unreachable or permissions denied] | `JSON` defining error status (e.g., `{"status": "error", "message": "Host script execution failed"}`, HTTP 500) |

***

## IV. Test Scenarios (Confirmation)

The Acceptance Criteria (ACs) confirm the functional contract using the Gherkin **Given/When/Then** syntax,.

### Scenario: Successful display of mixed VM states

```gherkin
Given the Hyper-V host is reachable
And the script Get-LabStatus.ps1 returns a JSON array containing:
  - VM "Web-Server-01" with State 'Running'
  - VM "Test-Env-02" with State 'Saved'
  - VM "Archive-03" with State 'Off'
When the dashboard loads the VM list
Then the list displays three items
And "Web-Server-01" shows the status **"Running"**
And "Test-Env-02" shows the status **"Saved"**
And "Archive-03" shows the status **"Off"**
```

### Scenario: Handling when NO VMs exist (Empty Array)

```gherkin
Given the Hyper-V host is reachable
And the script Get-LabStatus.ps1 returns an **empty JSON array** `[]`
When the dashboard loads the VM list
Then the dashboard displays zero VM items
And a message reading "No virtual machines found" is visible to the learner
```

### Scenario: Mapping non-specified Hyper-V state to an appropriate dashboard state

```gherkin
Given the Hyper-V host is reachable
And the script Get-LabStatus.ps1 returns a VM with the raw State 'Paused'
When the dashboard processes the VM list
Then that VM is displayed with the status **"Running"** (or appropriate operational status determined in the /plan)
And the dashboard does not crash or display an unhandled error
```