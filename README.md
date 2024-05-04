# PwshSQL
Helpful Powershell SQL functions

Yet another SQL Powershell module pull protection test

## Disclaimer
`PSModuleBuilder` is provided "as is," with no warranties, express or implied. The author is not liable for any claims, damages, or other liabilities, whether in a contract, tort, or other forms of action, arising from, out of, or in connection with the module or its use.

## Copyright
© 2020-2024 SysadminHeaven. All rights reserved.

# Example to do bulk statements
```
if (Test-Path .\test.sql) {
    Remove-Item .\test.sql
}
$object | Split-PSObject -SplitSize 998 | %{
    ConvertTo-SQLInsert -TableName "Customers" -Object $_.object | Out-File -FilePath ".\test.sql" -Append
}
```