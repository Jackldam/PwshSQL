function ConvertTo-SQLType {
    <#
    .SYNOPSIS
        This function converts an powershell object to a SQL type.
    .DESCRIPTION
        This function converts an powershell object to a SQL type.
        It will convert the following types:
        - System.String
        - System.Int32
        - System.DateTime
        - System.Boolean
    .PARAMETER value
        The value that needs to be converted to a SQL type.
    .NOTES
        File Name      : ConvertTo-SQLType.ps1
        Author         : Jack den Ouden
        Change history : 
            2024-05-04 - Initial creation
    .LINK
        https://github.com/Jackldam/PwshSQL
    .EXAMPLE
        ConvertTo-SQLType -value "Hello World"
    .EXAMPLE
        ConvertTo-SQLType -value 30
    .EXAMPLE    
        ConvertTo-SQLType -value (Get-Date)
    .EXAMPLE
        ConvertTo-SQLType -value $true
    .EXAMPLE
        ConvertTo-SQLType -value $false
    #>
    param(
        [Parameter(Mandatory)]
        [object]$value
    )
    switch ($value.GetType().FullName) {
        "System.String" {
            "'$value'"
        }
        "System.Int32" {
            "'$value'"
        }
        "System.DateTime" {
            "'$(Get-Date $value -Format 'yyyy-MM-dd HH:mm:ss')'"
        }
        "System.Boolean" {
            "'$(if ($value) {1} else {0})'"
        }
        default {
            "'$value'"
        }
    }
}