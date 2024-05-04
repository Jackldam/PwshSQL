$PSModuleParams = @{
    Author        = "Jack den Ouden"
    CompanyName   = "SysadminHeaven"
    ModuleName    = "PwshSQL"
    Copyright     = "© 2020-$(Get-Date -Format "yyyy") SysadminHeaven. All rights reserved."
    Source        = ".\Src" #Location functions and tests
    BuildFolder   = ".\Build"
    ReleaseFolder = ".\Release"
    BuildType     = "build"
}

Import-Module -Name "C:\REPO\PwshSQL\Build\PwshSQL"

$Ojbect = 1..10 | ForEach-Object { [PSCustomObject]@{Name = "$_" ; Age = 30 ; BirthDate = Get-Date ; Active = $true } }
ConvertTo-SQLInsert -tableName "Customers" -Object $Ojbect