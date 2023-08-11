#Import-Module
& "$PSScriptRoot\updateATAP.ps1"
$global:CISToAttackMappingData = Get-Content -Raw "$PSScriptRoot\..\resources\CISToAttackMappingData.json" | ConvertFrom-Json

InModuleScope ATAPHtmlReport {
    function global:Add-ToAuditInfos{
        param(
            [Parameter(Mandatory = $true)]
            [string]
            $Mitigation,
            [Parameter(Mandatory = $true)]
            [bool]
            $AllIDsFalse
        )
        $json = $CISToAttackMappingData.'CISAttackMapping'
        $json.psobject.properties.name | Where-Object {$json.$_.'Mitigation1' -eq $Mitigation -or $json.$_.'Mitigation2' -eq $Mitigation} | ForEach-Object {return $json.$_.'Recommendation'} | ForEach-Object {
            if($AllIDsFalse) {
                $global:AuditInfos += @{
                    Id = $_
                    Status = [AuditInfoStatus]::False
                }
            }
            else {
                $global:AuditInfos += @{
                    Id = $_
                    Status = [AuditInfoStatus]::True
                }
            }
        }
    }
    Describe 'testing function Get-MitigationsFromFailedTests' {
        It 'tests the amount of techniques in report' {
            $global:AuditInfos = @()

            $global:AuditInfos += @{
                #T1489
                Id = "18.8.5.3"
                Status = [AuditInfoStatus]::False
            }
            $global:AuditInfos += @{
                #T1555
                Id = "18.9.65.2.2"
                Status = [AuditInfoStatus]::False
            }
            $global:AuditInfos += @{
                #T1569 #T1011
                Id = "5.1"
                Status = [AuditInfoStatus]::False
            }
            $global:AuditInfos += @{
                #T1115
                Id = "2.2.1"
                Status = [AuditInfoStatus]::False
            }
            $global:AuditInfos += @{
                #T1048
                Id = "5.12"
                Status = [AuditInfoStatus]::False
            }
            $global:AuditInfos += @{
                #T1059
                Id = "18.9.31.4"
                Status = [AuditInfoStatus]::False
            }
            $global:AuditInfos += @{
                #T1003
                Id = "1.1.7"
                Status = [AuditInfoStatus]::False
            }
            $global:AuditInfos += @{
                #T1016
                Id = "18.5.19.2.1"
                Status = [AuditInfoStatus]::False
            }

            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }

            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests

            $json = $CISToAttackMappingData.'CISAttackMapping'

            foreach($Mitigation in $CISAMitigations.Keys) {
                $Techniques = @()
                $global:AuditInfos | Where-Object {$_.Status -eq [AuditInfoStatus]::False} | 
                Where-Object {$json.($_.Id).'Mitigation1' -eq $Mitigation -or $json.($_.Id).'Mitigation2' -eq $Mitigation} |
                ForEach-Object {
                    if($null -ne $json.($_.Id).'Technique1' -and $Techniques -notcontains $json.($_.Id).'Technique1'){
                        $Techniques += $json.($_.Id).'Technique1'
                    }
                    if($null -ne $json.($_.Id).'Technique2' -and $Techniques -notcontains $json.($_.Id).'Technique2'){
                        $Techniques += $json.($_.Id).'Technique2'
                    }
                }
                $Techniques = $Techniques | Sort-Object
                $CISAMitigations[$Mitigation]['MitreTechniqueIDs'] = $CISAMitigations[$Mitigation]['MitreTechniqueIDs'] | Sort-Object
                for($i = 0; $i -lt $CISAMitigations[$Mitigation]['MitreTechniqueIDs'].length; $i++) {
                    $CISAMitigations[$Mitigation]['MitreTechniqueIDs'][$i] | Should -Be $Techniques[$i]
                }
            }
        }
        It 'tests with an example report where every status is [AuditInfoStatus]::False' {
            $global:AuditInfos = @()

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $true
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }

            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Be @('M1017', 'M1018', 'M1021', 'M1027', 'M1028', 'M1030', 'M1031', 'M1038', 'M1041', 'M1042')
        }
        It 'tests with an example report where every status is [AuditInfoStatus]::True' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $false
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Be @()
        }
        It 'tests with an example report where just M1017 ids are [AuditInfoStatus]::False' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $false
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Contain @('M1017')
        }
        It 'tests with an example report where just M1018 ids are [AuditInfoStatus]::False' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $false
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Contain @('M1018')
        }
        It 'tests with an example report where just M1021 ids are [AuditInfoStatus]::False' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $false
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Contain @('M1021')
        }
        It 'tests with an example report where just M1027 ids are [AuditInfoStatus]::False' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $false
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Contain @('M1027')
        }
        It 'tests with an example report where just M1028 ids are [AuditInfoStatus]::False' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $false
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Contain @('M1028')
        }
        It 'tests with an example report where just M1030 ids are [AuditInfoStatus]::False' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $false
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Contain @('M1030')
        }
        It 'tests with an example report where just M1031 ids are [AuditInfoStatus]::False' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $false
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Contain @('M1031')
        }
        It 'tests with an example report where just M1038 ids are [AuditInfoStatus]::False' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $false
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Contain @('M1038')
        }
        It 'tests with an example report where just M1041 ids are [AuditInfoStatus]::False' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $true
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $false
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Contain @('M1041')
        }
        It 'tests with an example report where just M1042 ids are [AuditInfoStatus]::False' {
            $global:AuditInfos = @() 

            Add-ToAuditInfos -Mitigation 'M1017' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1018' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1021' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1027' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1028' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1030' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1031' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1038' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1041' -AllIDsFalse $false
            Add-ToAuditInfos -Mitigation 'M1042' -AllIDsFalse $true
            
            $Subsection = @{AuditInfos = $global:AuditInfos }
            $Section1 = @{
                Title = "Cis Benchmarks"
                SubSections = $Subsection
            }
            
            $mitreMap = $Section1 | Where-Object { $_.Title -eq "CIS Benchmarks" } | ForEach-Object { return $_.SubSections } | ForEach-Object { return $_.AuditInfos } | Merge-CisAuditsToMitreMap

            #Tests
            $CISAMitigations = $mitreMap.Map | Get-MitigationsFromFailedTests
            $CISAMitigations.Keys | Should -Contain @('M1042')
        }
    }
}