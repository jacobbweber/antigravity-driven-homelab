
Describe "Get-HostStats" {
    BeforeAll {
        $scriptPath = "$PSScriptRoot/../../../scripts/Get-HostStats.ps1"
        if (-not (Test-Path $scriptPath)) {
            $scriptPath = "$PWD/scripts/Get-HostStats.ps1"
        }
        $sutScript = (Resolve-Path $scriptPath).Path
    }

    Context "When sensors are accessible" {
        It "Returns correct CPU and Memory metrics" {
            # Mock Memory: 16GB Total (16777216 KB), 8GB Free (8388608 KB) -> 8GB Used
            Mock Get-CimInstance {
                param($ClassName, $ErrorAction)
                
                if ($ClassName -eq 'Win32_OperatingSystem') {
                    return [PSCustomObject]@{
                        TotalVisibleMemorySize = 16777216
                        FreePhysicalMemory     = 8388608
                    }
                }
                # Mock CPU: 2 Cores, 25% Load each
                if ($ClassName -eq 'Win32_Processor') {
                    return @(
                        [PSCustomObject]@{ LoadPercentage = 25 },
                        [PSCustomObject]@{ LoadPercentage = 25 }
                    )
                }
            } 

            $resultJSON = & $sutScript
            $result = $resultJSON | ConvertFrom-Json
            
            $stats = $result.host_stats
            $stats.cpu_utilization_percent | Should -Be 25
            $stats.memory_total_gb | Should -Be 16.0
            $stats.memory_used_gb | Should -Be 8.0
        }
    }

    Context "When CIM fails" {
        It "Returns an error object" {
            Mock Get-CimInstance { throw "CIM Error" } 

            $resultJSON = & $sutScript
            $result = $resultJSON | ConvertFrom-Json
            
            $result.status | Should -Be "error"
            $result.message | Should -Match "CIM Error"
        }
    }
}
