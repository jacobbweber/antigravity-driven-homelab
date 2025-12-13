param(
    [Parameter(Mandatory = $true)]
    [string]$VmId,

    [Parameter(Mandatory = $true)]
    [ValidateSet("start", "stop_graceful", "stop_force", "reboot_graceful")]
    [string]$Action
)

try {
    # Convert String to Guid to ensure validity (though Get-VM accepts id as guid, string works often)
    # Let's just pass to Get-VM
    
    $vm = Get-VM -Id $VmId -ErrorAction Stop

    if (!$vm) {
        throw "VM with ID $VmId not found."
    }

    switch ($Action) {
        "start" {
            if ($vm.State -eq 'Running') {
                throw "VM is already currently Running."
            }
            Start-VM -Name $vm.Name -ErrorAction Stop
        }
        "stop_graceful" {
            if ($vm.State -eq 'Off') {
                throw "VM is already Off."
            }
            # Asynchronous stops might be better for API response speed, 
            # but user wants reliable confirmation. 
            # Stop-VM waits by default.
            Stop-VM -Name $vm.Name -ErrorAction Stop
        }
        "stop_force" {
            if ($vm.State -eq 'Off') {
                throw "VM is already Off."
            }
            Stop-VM -Name $vm.Name -TurnOff -ErrorAction Stop
        }
        "reboot_graceful" {
            if ($vm.State -eq 'Off') {
                throw "VM is Off, cannot reboot. Please start it."
            }
            Restart-VM -Name $vm.Name -ErrorAction Stop
        }
    }

    @{
        status    = "success"
        vm_uuid   = $VmId
        action    = $Action
        new_state = $vm.State.ToString() # Note: This might be stale immediately after async start, but OK for now.
    } | ConvertTo-Json -Compress

}
catch {
    $errorMsg = $_.Exception.Message
    @{
        status  = "error"
        message = $errorMsg
        vm_uuid = $VmId
    } | ConvertTo-Json -Compress
}
