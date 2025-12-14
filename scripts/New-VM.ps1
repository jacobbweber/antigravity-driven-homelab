param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [Parameter(Mandatory = $true)]
    [int]$CpuCores,

    [Parameter(Mandatory = $true)]
    [int]$RamStartupMB,

    [Parameter(Mandatory = $false)]
    [string]$SwitchName = "Default Switch",
    
    [Parameter(Mandatory = $false)]
    [string]$DiskTemplatePath
)

$ErrorActionPreference = "Stop"

try {
    Write-Output "Starting provisioning for VM: $Name"

    # 1. Check existence
    if (Get-VM -Name $Name -ErrorAction SilentlyContinue) {
        throw "VM '$Name' already exists."
    }

    # 2. Create VM Shell
    Write-Output "Creating VM shell..."
    # Generation 2 is standard for modern labs
    New-VM -Name $Name -MemoryStartupBytes ($RamStartupMB * 1MB) -Generation 2 -NoVHD | Out-Null

    # 3. Configure Processor
    Write-Output "Configuring resources..."
    Set-VMProcessor -VMName $Name -Count $CpuCores

    # 4. Network
    if ($SwitchName) {
        Connect-VMNetworkAdapter -VMName $Name -SwitchName $SwitchName
    }

    # 5. Disk Handling
    # If a template is provided, we copy it to the default VHD locations (or just VM's folder)
    if (-not [string]::IsNullOrWhiteSpace($DiskTemplatePath)) {
        if (-not (Test-Path $DiskTemplatePath)) {
            throw "Disk template not found at $DiskTemplatePath"
        }
        
        # Get Hyper-V Virtual Hard Disks path
        $vhdPath = (Get-VMHost).VirtualHardDiskPath
        if (-not $vhdPath) { $vhdPath = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks" }
        
        $destPath = Join-Path -Path $vhdPath -ChildPath "${Name}.vhdx"
        
        Write-Output "Copying disk template to $destPath..."
        Copy-Item -Path $DiskTemplatePath -Destination $destPath
        
        Write-Output "Attaching disk..."
        Add-VMHardDiskDrive -VMName $Name -Path $destPath
        
        # Ensure boot order (Disk first)
        $hdd = Get-VMHardDiskDrive -VMName $Name
        Set-VMFirmware -VMName $Name -FirstBootDevice $hdd
    }

    # 6. Start
    Write-Output "Starting VM..."
    Start-VM -Name $Name

    @{
        status  = "success"
        vm_name = $Name
        message = "VM created and started."
    } | ConvertTo-Json -Compress

}
catch {
    Write-Error $_.Exception.Message
    @{
        status  = "error"
        message = $_.Exception.Message
    } | ConvertTo-Json -Compress
    exit 1
}
