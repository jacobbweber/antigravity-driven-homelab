document.addEventListener('DOMContentLoaded', () => {
    const btnProvision = document.getElementById('btn-provision');
    const btnDestroy = document.getElementById('btn-destroy');
    const consoleOutput = document.getElementById('console-output');

    // Status Elements
    // Dynamic rendering replaces static statusMap

    // Polling Intervals
    let statusInterval;
    let logInterval;

    function addLog(message, type = 'normal') {
        const line = document.createElement('div');
        line.className = `log-line ${type}`;
        line.textContent = `> ${message}`;
        consoleOutput.appendChild(line);
        consoleOutput.scrollTop = consoleOutput.scrollHeight;
    }

    // Control VM Action
    window.controlVm = async function (uuid, action) {
        addLog(`Sending ${action} to VM...`, 'system');

        try {
            const res = await fetch('/api/control', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ vm_uuid: uuid, action: action })
            });
            const data = await res.json();

            if (res.status === 202) {
                addLog(`Success: Command accepted.`, 'success');
                // Trigger immediate status refresh
                setTimeout(fetchStatus, 500);
            } else {
                addLog(`Error: ${data.message || 'Unknown error'}`, 'error');
            }
        } catch (e) {
            addLog(`Request Failed: ${e}`, 'error');
        }
    };

    // Event Delegation for Dynamic Buttons
    document.addEventListener('click', (e) => {
        if (e.target && e.target.classList.contains('btn-control')) {
            const uuid = e.target.dataset.uuid;
            const action = e.target.dataset.action;
            if (uuid && action) {
                window.controlVm(uuid, action);
            }
        }
    });

    const cpuTempEl = document.getElementById('cpu-temp');
    const cpuUnitEl = document.getElementById('cpu-unit');

    const hostCpuEl = document.getElementById('host-cpu-load');
    const hostMemUsedEl = document.getElementById('host-mem-used');
    const hostMemTotalEl = document.getElementById('host-mem-total');

    async function fetchHostStats() {
        try {
            const res = await fetch('/api/host/stats');
            const data = await res.json();

            if (data.host_stats) {
                hostCpuEl.textContent = data.host_stats.cpu_utilization_percent;
                hostMemUsedEl.textContent = data.host_stats.memory_used_gb;
                hostMemTotalEl.textContent = data.host_stats.memory_total_gb;
            } else {
                hostCpuEl.textContent = "--";
            }
        } catch (e) {
            console.error('Failed to fetch host stats', e);
        }
    }

    async function fetchCpuTemp() {
        try {
            const res = await fetch('/api/cputemp');
            const data = await res.json();

            if (data.temperature !== undefined) {
                cpuTempEl.textContent = data.temperature;
                cpuUnitEl.textContent = data.unit;
            } else {
                cpuTempEl.textContent = "ERR";
            }
        } catch (e) {
            console.error('Failed to fetch temp', e);
            cpuTempEl.textContent = "--";
        }
    }

    function getActionsHtml(vm) {
        let btns = '';
        const uuid = vm.vm_uuid;

        if (vm.dashboard_status === 'Running') {
            btns += `<button class="btn-sm btn-control" data-uuid="${uuid}" data-action="stop_graceful" title="Graceful Shutdown">Stop</button>`;
            btns += `<button class="btn-sm btn-control" data-uuid="${uuid}" data-action="reboot_graceful" title="Reboot">Reboot</button>`;
            btns += `<button class="btn-sm btn-control danger" data-uuid="${uuid}" data-action="stop_force" title="Force Stop">Kill</button>`;
        } else if (vm.dashboard_status === 'Off' || vm.dashboard_status === 'Saved') {
            btns += `<button class="btn-sm btn-control success" data-uuid="${uuid}" data-action="start">Start</button>`;
        }

        return `<div class="card-actions">${btns}</div>`;
    }

    async function fetchStatus() {
        try {
            const res = await fetch('/api/status');
            const data = await res.json();

            if (!Array.isArray(data)) return;

            const dashboard = document.getElementById('dashboard-grid');
            const cpuCard = document.getElementById('card-cputemp');

            if (!dashboard || !cpuCard) return;

            // Track current VM IDs in data
            const currentVmIds = new Set(data.map(vm => vm.vm_uuid));

            // 1. Remove cards not in data
            document.querySelectorAll('.vm-card').forEach(card => {
                const uuid = card.dataset.uuid;
                if (!currentVmIds.has(uuid)) {
                    card.remove();
                }
            });

            // 2. Update or Create
            data.forEach(vm => {
                let card = document.getElementById(`vm-${vm.vm_uuid}`);
                let statusClass = 'unknown';
                if (vm.dashboard_status === 'Running') statusClass = 'running';
                else if (vm.dashboard_status === 'Off') statusClass = 'off';

                if (card) {
                    // Update existing
                    const h3 = card.querySelector('h3');
                    if (h3) h3.textContent = vm.display_name;

                    const indicator = card.querySelector('.status-indicator');
                    if (indicator) indicator.className = `status-indicator ${statusClass}`;

                    const spans = card.querySelectorAll('.card-body span');
                    if (spans.length >= 2) {
                        spans[0].textContent = vm.dashboard_status;
                        spans[1].textContent = vm.uptime_seconds !== null ? vm.uptime_seconds : '-';
                    }

                    // Update actions
                    const actionsDiv = card.querySelector('.card-actions');
                    const newActionsStr = getActionsHtml(vm);
                    if (actionsDiv) {
                        if (actionsDiv.outerHTML !== newActionsStr) {
                            actionsDiv.outerHTML = newActionsStr;
                        }
                    } else {
                        // Fallback if missing
                        const body = card.querySelector('.card-body');
                        if (body) body.insertAdjacentHTML('beforeend', newActionsStr);
                    }

                } else {
                    // Create new
                    card = document.createElement('div');
                    card.className = 'card vm-card';
                    card.id = `vm-${vm.vm_uuid}`;
                    card.dataset.uuid = vm.vm_uuid;

                    card.innerHTML = `
                        <div class="card-header">
                            <div class="status-indicator ${statusClass}"></div>
                            <h3>${vm.display_name}</h3>
                        </div>
                        <div class="card-body">
                            <p>Status: <span>${vm.dashboard_status}</span></p>
                            <p>Uptime: <span>${vm.uptime_seconds !== null ? vm.uptime_seconds : '-'}</span></p>
                            ${getActionsHtml(vm)}
                        </div>
                    `;
                    dashboard.insertBefore(card, cpuCard);
                }
            });

            // Handle empty state
            const emptyMsg = document.getElementById('no-vms-msg');
            if (data.length === 0) {
                if (!emptyMsg) {
                    const msg = document.createElement('p');
                    msg.id = 'no-vms-msg';
                    msg.style.gridColumn = "1 / -1";
                    msg.style.textAlign = "center";
                    msg.style.color = "var(--text-secondary)";
                    msg.textContent = "No virtual machines found.";
                    dashboard.insertBefore(msg, cpuCard);
                }
            } else {
                if (emptyMsg) emptyMsg.remove();
            }

        } catch (e) {
            console.error('Failed to fetch status', e);
        }
    }

    async function pollLogs() {
        try {
            const res = await fetch('/api/logs');
            const data = await res.json();
            if (data.logs && data.logs.length > 0) {
                // Clear console if needed or just append. 
                // For simplicity, we replaced the lists in backend, but here let's just append new ones? 
                // Actually server returns ALL logs or updates?
                // Plan said "latest lines". Let's assume server returns full buffer for now or we handle index.
                // Re-implementation: Clear and Fill is easier for small buffers.
                consoleOutput.innerHTML = '';
                data.logs.forEach(msg => addLog(msg));
            }
        } catch (e) {
            console.error('Failed to fetch logs', e);
        }
    }

    async function triggerAction(action) {
        btnProvision.disabled = true;
        btnDestroy.disabled = true;
        addLog(`Initiating ${action}...`, 'system');

        try {
            await fetch(`/api/${action}`, { method: 'POST' });
            // Start polling logs aggressively
            logInterval = setInterval(pollLogs, 1000);
        } catch (e) {
            addLog(`Error triggering ${action}: ${e}`, 'system');
            btnProvision.disabled = false;
            btnDestroy.disabled = false;
        }
    }

    btnProvision.addEventListener('click', () => triggerAction('provision'));
    btnDestroy.addEventListener('click', () => triggerAction('destroy'));

    // Initial Status Check
    fetchStatus();
    fetchCpuTemp();
    fetchHostStats();
    statusInterval = setInterval(() => {
        fetchStatus();
        fetchCpuTemp();
        fetchHostStats();
    }, 5000);
    // Poll logs gently
    logInterval = setInterval(pollLogs, 2000);

    // Modal & Provisioning Logic
    const modal = document.getElementById('provision-modal');
    const btnNewVm = document.getElementById('btn-new-vm');
    const closeSpan = document.querySelector('.close-modal');
    const btnCancel = document.querySelector('.cancel-modal');
    const provisionForm = document.getElementById('provision-form');

    if (btnNewVm) {
        btnNewVm.onclick = () => {
            modal.classList.remove('hidden');
        };
    }

    function closeModal() {
        if (modal) modal.classList.add('hidden');
    }

    if (closeSpan) closeSpan.onclick = closeModal;
    if (btnCancel) btnCancel.onclick = closeModal;

    window.onclick = (event) => {
        if (event.target == modal) {
            closeModal();
        }
    }

    if (provisionForm) {
        provisionForm.onsubmit = async (e) => {
            e.preventDefault();

            const vmName = document.getElementById('vm-name').value;
            const vmCpu = document.getElementById('vm-cpu').value;
            const vmRam = document.getElementById('vm-ram').value;
            const vmSwitch = document.getElementById('vm-switch').value;
            const vmDisk = document.getElementById('vm-disk').value;

            addLog('Submitting Provisioning Request...', 'system');

            const payload = {
                provisioning_request: {
                    num_vms: 1,
                    vms: [{
                        vm_name: vmName,
                        cpu_cores: parseInt(vmCpu),
                        ram_startup_mb: parseInt(vmRam),
                        network_adapter_name: vmSwitch,
                        disk_template_path: vmDisk
                    }]
                }
            };

            try {
                const res = await fetch('/api/vms/provision', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });

                const data = await res.json();

                if (res.status === 202) {
                    addLog(`Job Submitted. ID: ${data.provisioning_job_response.job_id}`, 'success');
                    closeModal();
                    // Start polling logs aggressively
                    clearInterval(logInterval);
                    logInterval = setInterval(pollLogs, 1000);
                    // Reset form
                    provisionForm.reset();
                } else {
                    addLog(`Error: ${data.error}`, 'error');
                    alert(`Error: ${data.error}`);
                }
            } catch (err) {
                addLog(`Request Exception: ${err}`, 'error');
                alert(`Request Failed: ${err}`);
            }
        };
    }
});
