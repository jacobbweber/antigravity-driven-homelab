Describe "Get-CpuTemp" {
    BeforeAll {
        $sut = (Resolve-Path "$PSScriptRoot/../../../scripts/Get-CpuTemp.ps1").Path
    }

    Context "When hardware sensors are accessible" {
        
        # Manually define function to shadow cmdlet if Mock is failing
        function Get-CimInstance {
            param($Namespace, $ClassName, $ErrorAction) 
            return [PSCustomObject]@{ CurrentTemperature = 3010 }
        }


        It "Returns the correct temperature in Celsius" {
            function Get-CimInstance { param($Namespace, $ClassName, $ErrorAction) return [PSCustomObject]@{ CurrentTemperature = 3010 } }
            
            $resultJSON = . "$sut"
            Write-Host "Raw Output: $resultJSON"
            $result = $resultJSON | ConvertFrom-Json

            $result.temperature | Should -Be 27.85
            $result.unit | Should -Be "C"
        }

        It "Output is valid JSON" {
            $resultJSON = . "$sut"
            { $resultJSON | ConvertFrom-Json } | Should -Not -Throw
        }
    }

    Context "When sensors fail or are missing" {
        Mock Get-CimInstance {
            throw "CIM Error"
        }

        It "Returns an error JSON structure" {
            $resultJSON = . "$sut"
            $result = $resultJSON | ConvertFrom-Json

            $result.status | Should -Be "error"
            $result.message | Should -Not -BeNullOrEmpty
        }
    }
}
