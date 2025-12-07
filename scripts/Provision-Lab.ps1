# Provision-Lab.ps1
# Creates the Lab VMs

param(
    [string]$SwitchName = "Default Switch"
)

$vmConfigs = @(
    @{ Name = "AG-Lab-Win"; Memory = 2GB; Generation = 2 },
    @{ Name = "AG-Lab-Linux"; Memory = 1GB; Generation = 2 }
)

Write-Output "Starting Provisioning Process..."

foreach ($config in $vmConfigs) {
    $vmName = $config.Name
    Write-Output "Checking $vmName..."

    if (Get-VM -Name $vmName -ErrorAction SilentlyContinue) {
        Write-Output "  $vmName already exists. Skipping creation."
    } else {
        Write-Output "  Creating $vmName..."
        try {
            New-VM -Name $vmName -MemoryStartupBytes $config.Memory -Generation $config.Generation -SwitchName $SwitchName -ErrorAction Stop | Out-Null
            Write-Output "  $vmName created successfully."
            
            # Add a dummy hard drive just so it has one (optional, or skip if no ISO/VHDX provided)
            # For this demo, we leave it as a shell VM.
            
            Write-Output "  Configuring settings for $vmName..."
            Set-VM -Name $vmName -CheckpointType Disabled
        } catch {
            Write-Error "  Failed to create $vmName : $_"
        }
    }
    
    # Ensure it's running
    $vm = Get-VM -Name $vmName
    if ($vm.State -ne 'Running') {
        Write-Output "  Starting $vmName..."
        Start-VM -Name $vmName
    }
}

Write-Output "Provisioning Complete."
