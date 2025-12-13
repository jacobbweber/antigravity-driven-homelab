# Get-LabStatus.ps1
# Retrieves status of all local Hyper-V VMs as per the new spec

$vmList = @()

# Fetch all VMs on the host
try {
    $vms = Get-VM -ErrorAction Stop

    foreach ($vm in $vms) {
        $dashboardStatus = switch ($vm.State) {
            "Running" { "Running" }
            "Off" { "Off" }
            "Saved" { "Saved" }
            "Paused" { "Running" } # Map Paused to Running as per spec
            Default { "Off" }
        }

        $uptime = if ($vm.State -eq 'Running') { $vm.Uptime.TotalSeconds } else { $null }

        $vmList += @{
            display_name     = $vm.Name
            vm_uuid          = $vm.Id.ToString()
            hyperv_raw_state = $vm.State.ToString()
            dashboard_status = $dashboardStatus
            uptime_seconds   = $uptime
        }
    }
}
catch {
    # If fetch fails (e.g. no Hyper-V), return empty list or specific error structure? 
    # Spec says "No VMs found" is an empty array scenario.
    # If command fails entirely, we might output nothing or empty list.
    # For now, let's assume if Get-VM fails it returns empty.
    $vmList = @() 
}

$vmList | ConvertTo-Json -Depth 2
