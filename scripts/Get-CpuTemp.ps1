# Get-CpuTemp.ps1
# Retrieves the current CPU temperature from WMI

try {
    $tempInfo = Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction Stop | Select-Object -First 1
    
    if ($tempInfo) {
        # Convert DeciKelvin to Celsius
        # Formula: (dK / 10) - 273.15
        $celsius = ($tempInfo.CurrentTemperature / 10) - 273.15
        
        # Round to 2 decimal places
        $celsius = [math]::Round($celsius, 2)

        $response = @{
            temperature = $celsius
            unit        = "C"
            timestamp   = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
    }
    else {
        throw "No thermal zone information found."
    }
}
catch {
    $response = @{
        status  = "error"
        message = "Hardware monitoring service offline or inaccessible: $_"
    }
}

$response | ConvertTo-Json -Compress
