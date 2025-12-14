try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
    $cpus = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop 
    
    # Calculate Average CPU Load across all sockets/cores presented by Win32_Processor
    # Note: Measure-Object -Property LoadPercentage -Average handles array or single object
    $cpuStats = $cpus | Measure-Object -Property LoadPercentage -Average
    
    $totalMemGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $freeMemGB = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    $usedMemGB = [math]::Round($totalMemGB - $freeMemGB, 1)
    $cpuLoad = [math]::Round($cpuStats.Average, 1)

    @{
        host_stats = @{
            cpu_utilization_percent = $cpuLoad
            memory_used_gb          = $usedMemGB
            memory_total_gb         = $totalMemGB
            timestamp               = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
    } | ConvertTo-Json -Depth 2
}
catch {
    @{
        status  = "error"
        message = $_.Exception.Message
    } | ConvertTo-Json -Compress
}
