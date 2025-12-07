# Destroy-Lab.ps1
# Destroys the Lab VMs

$vmNames = @("AG-Lab-Win", "AG-Lab-Linux")

Write-Output "Starting Destruction Process..."

foreach ($name in $vmNames) {
    if (Get-VM -Name $name -ErrorAction SilentlyContinue) {
        Write-Output "Found $name. Stopping..."
        Stop-VM -Name $name -TurnOff -Force -ErrorAction SilentlyContinue
        
        Write-Output "Removing $name..."
        Remove-VM -Name $name -Force -ErrorAction Stop
        Write-Output "$name removed."
    } else {
        Write-Output "$name not found. Skipping."
    }
}

Write-Output "Destruction Complete."
