
Describe "Control-VMState" {
    BeforeAll {
        $scriptPath = "$PSScriptRoot/../../../scripts/Control-VMState.ps1"
        if (-not (Test-Path $scriptPath)) {
            $scriptPath = "$PWD/scripts/Control-VMState.ps1"
        }
        $sutScript = (Resolve-Path $scriptPath).Path
    }

    Context "Input Validation" {
        It "Fails when Action is invalid" {
            $id = [Guid]::NewGuid()
            # If we call with invalid action validation set, PS throws a parameter binding exception.
            # We need to catch that in the script block.
            { & $sutScript -VmId $id -Action "dance" } | Should -Throw -ErrorId "ParameterArgumentValidationError"
        }
    }

    Context "Action Execution" {
        # Mock Get-VM to return a dummy VM object
        
        It "Starts a VM when action is 'start'" {
            Mock Get-VM {
                param($Id)
                return [PSCustomObject]@{ Id = $Id; State = 'Off'; Name = "TestVM" } 
            }
            Mock Start-VM { param($Name, $VM, $ErrorAction) } 

            $id = [Guid]::NewGuid()
            $resultJSON = & $sutScript -VmId $id -Action "start"
            $result = $resultJSON | ConvertFrom-Json

            if ($result.status -ne "success") { Write-Host "Error Message: $($result.message)" }
            $result.status | Should -Be "success"
            
            Assert-MockCalled Start-VM -Times 1
        }

        It "Gracefully stops a VM when action is 'stop_graceful'" {
            Mock Get-VM { 
                param($Id)
                return [PSCustomObject]@{ Id = $Id; State = 'Running'; Name = "TestVM" } 
            }
            Mock Stop-VM { param($Name, $VM, $ErrorAction, $TurnOff) } 

            $id = [Guid]::NewGuid()
            $resultJSON = & $sutScript -VmId $id -Action "stop_graceful"
            $result = $resultJSON | ConvertFrom-Json

            if ($result.status -ne "success") { Write-Host "Error Message: $($result.message)" }
            $result.status | Should -Be "success"
            Assert-MockCalled Stop-VM -Times 1
        }
        
        It "Forcefully stops a VM when action is 'stop_force'" {
            Mock Get-VM { 
                param($Id)
                return [PSCustomObject]@{ Id = $Id; State = 'Running'; Name = "TestVM" } 
            }
            Mock Stop-VM { param($Name, $VM, $ErrorAction, $TurnOff) } 

            $id = [Guid]::NewGuid()
            $resultJSON = & $sutScript -VmId $id -Action "stop_force"
            $result = $resultJSON | ConvertFrom-Json
            
            if ($result.status -ne "success") { Write-Host "Error Message: $($result.message)" }
            $result.status | Should -Be "success"
            Assert-MockCalled Stop-VM -Times 1 -ParameterFilter { $TurnOff -eq $true }
        }

        It "Reboots a VM when action is 'reboot_graceful'" {
            Mock Get-VM { 
                param($Id)
                return [PSCustomObject]@{ Id = $Id; State = 'Running'; Name = "TestVM" } 
            }
            Mock Restart-VM { param($Name, $VM, $ErrorAction) } 

            $id = [Guid]::NewGuid()
            $resultJSON = & $sutScript -VmId $id -Action "reboot_graceful"
            $result = $resultJSON | ConvertFrom-Json
            
            if ($result.status -ne "success") { Write-Host "Error Message: $($result.message)" }
            $result.status | Should -Be "success"
            Assert-MockCalled Restart-VM -Times 1
        }
    }
    
    Context "Error Handling" {
        It "Returns error if VM not found" {
            Mock Get-VM { throw [System.Exception]"VM not found" }

            $id = [Guid]::NewGuid()
            $resultJSON = & $sutScript -VmId $id -Action "start"
            $result = $resultJSON | ConvertFrom-Json

            $result.status | Should -Be "error"
            $result.message | Should -Match "VM not found"
        }
    }
}
