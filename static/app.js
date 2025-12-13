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

    const cpuTempEl = document.getElementById('cpu-temp');
    const cpuUnitEl = document.getElementById('cpu-unit');

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
    statusInterval = setInterval(() => {
        fetchStatus();
        fetchCpuTemp();
    }, 5000);
    // Poll logs gently
    logInterval = setInterval(pollLogs, 2000);
});
