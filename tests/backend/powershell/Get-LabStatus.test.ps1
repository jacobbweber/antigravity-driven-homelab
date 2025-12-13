Describe "Get-LabStatus" {
    BeforeAll {
        $scriptPath = "$PSScriptRoot/../../../scripts/Get-LabStatus.ps1"
        if (-not (Test-Path $scriptPath)) {
            Write-Warning "PSScriptRoot path failed. Trying PWD fallback."
            $scriptPath = "$PWD/scripts/Get-LabStatus.ps1"
        }
        $sutScript = (Resolve-Path $scriptPath).Path
        Write-Host "DEBUG: SUT Script resolved to: $sutScript"
    }

    Context "When VMs exist" {
        It "Returns the correct list of VMs" {
            # Define mocks in scope
            function Get-VM { 
                param($Name)
                if ($Name) { return $null } 
                return @(
                    [PSCustomObject]@{ Name = "Web-Server-01"; Id = [Guid]::NewGuid(); State = "Running"; Uptime = [TimeSpan]::FromSeconds(3600) },
                    [PSCustomObject]@{ Name = "Test-Env-02"; Id = [Guid]::NewGuid(); State = "Saved"; Uptime = [TimeSpan]::FromSeconds(0) },
                    [PSCustomObject]@{ Name = "Archive-03"; Id = [Guid]::NewGuid(); State = "Off"; Uptime = [TimeSpan]::FromSeconds(0) }
                )
            }

            $raw = Get-Content -Path $sutScript -Raw
            $resultJSON = Invoke-Expression $raw
            $result = $resultJSON | ConvertFrom-Json

            $result.Count | Should -Be 3
            $result | Where-Object { $_.display_name -eq "Web-Server-01" } | Select-Object -ExpandProperty dashboard_status | Should -Be "Running"
        }
    }

    Context "When NO VMs exist" {
        It "Returns an empty array" {
            function Get-VM { return @() }
            
            $raw = Get-Content -Path $sutScript -Raw
            $resultJSON = Invoke-Expression $raw
            $result = $resultJSON | ConvertFrom-Json

            $result.Count | Should -Be 0
        }
    }
}
