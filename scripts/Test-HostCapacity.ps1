param(
    [Parameter(Mandatory = $true)]
    [int]$RamMB,
    
    [Parameter(Mandatory = $true)]
    [int]$CpuCores
)

try {
    # 1. Check Memory
    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
    $freeMemMB = [math]::Round($os.FreePhysicalMemory / 1024, 0)
    
    # Simple check: Request must be strictly less than Free Memory 
    # (leaving some buffer for Host OS would be wise, say 2GB buffer)
    $bufferMB = 2048
    if ($RamMB -gt ($freeMemMB - $bufferMB)) {
        throw "Insufficient Memory. Requested: ${RamMB}MB, Available (w/ buffer): $([math]::Round($freeMemMB - $bufferMB))MB"
    }

    # 2. Check CPU
    # Hyper-V allows overprovisioning, but spec example implied a hard limit check against physical/logical count.
    $cpus = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop 
    $totalCores = ($cpus | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum

    if ($CpuCores -gt $totalCores) {
        throw "Insufficient CPU Resources. Requested: $CpuCores cores, Host Total: $totalCores threads"
    }

    @{
        valid   = $true
        message = "Resources available."
    } | ConvertTo-Json -Compress

}
catch {
    @{
        valid   = $false
        message = $_.Exception.Message
    } | ConvertTo-Json -Compress
}
