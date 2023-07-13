#Import-Module
& "$PSScriptRoot\updateATAP.ps1"

InModuleScope ATAPHtmlReport {
    Describe 'Testing Merge-CisAuditsToMitreMap' {
        It 'tests with an example Report' {
            $json = Get-Content -Raw "$PSScriptRoot\..\TechniquesToTactics.json" | ConvertFrom-Json
            <#$json."T1591" | Should -Be 'TA0043'
            $json."T1056" | Should -Be 'TA0009', 'TA0006'
            Write-Host $json.getType()#>
            Get-MitreTactics -json $json -TechniqueID "T1591" | Should -Be 'TA0043'
            Get-MitreTactics -json $json -TechniqueID "T1056" | Should -Be 'TA0009', 'TA0006'
        }
    }
}