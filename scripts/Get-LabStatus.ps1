# Get-LabStatus.ps1
# Returns JSON status of the lab VMs

$vmNames = @("AG-Lab-Win", "AG-Lab-Linux")
$statusList = @()

foreach ($name in $vmNames) {
    if (Get-VM -Name $name -ErrorAction SilentlyContinue) {
        $vm = Get-VM -Name $name
        $statusList += @{
            name = $name
            status = $vm.State.ToString()
            uptime = $vm.Uptime.ToString()
        }
    } else {
        $statusList += @{
            name = $name
            status = "NonExistent"
            uptime = "N/A"
        }
    }
}

$statusList | ConvertTo-Json -Compress
