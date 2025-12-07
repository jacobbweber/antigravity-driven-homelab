document.addEventListener('DOMContentLoaded', () => {
    const btnProvision = document.getElementById('btn-provision');
    const btnDestroy = document.getElementById('btn-destroy');
    const consoleOutput = document.getElementById('console-output');

    // Status Elements
    const statusMap = {
        'AG-Lab-Win': {
            status: document.getElementById('status-win'),
            uptime: document.getElementById('uptime-win'),
            indicator: document.querySelector('#card-win .status-indicator')
        },
        'AG-Lab-Linux': {
            status: document.getElementById('status-linux'),
            uptime: document.getElementById('uptime-linux'),
            indicator: document.querySelector('#card-linux .status-indicator')
        }
    };

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

    async function fetchStatus() {
        try {
            const res = await fetch('/api/status');
            const data = await res.json();

            data.forEach(vm => {
                const els = statusMap[vm.name];
                if (els) {
                    els.status.textContent = vm.status;
                    els.uptime.textContent = vm.uptime;

                    // Update indicator
                    els.indicator.className = 'status-indicator'; // reset
                    if (vm.status === 'Running') els.indicator.classList.add('running');
                    else if (vm.status === 'Off') els.indicator.classList.add('off');
                    else els.indicator.classList.add('unknown');
                }
            });
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
    statusInterval = setInterval(fetchStatus, 5000);
    // Poll logs gently
    logInterval = setInterval(pollLogs, 2000);
});
