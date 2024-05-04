function ConvertTo-SQLInsert {
    <#
    .SYNOPSIS
        This function converts an object to a SQL INSERT statement.
    .DESCRIPTION
        This function converts an object to a SQL INSERT statement.
        If you have an object with more than 999 records, an error will be thrown.
        due to the limitation of the number of records that can be inserted in a single statement.
    .NOTES
        File Name      : ConvertTo-SQLInsert.ps1
        Author         : Jack den Ouden
        Change history : 
            2024-05-04 - Initial creation
    .LINK
        https://github.com/Jackldam/PwshSQL
    .EXAMPLE
        $Ojbect = [PSCustomObject]@{Name = "$_" ; Age = 30 ; BirthDate = Get-Date ; Active = $true } 
        ConvertTo-SQLInsert -tableName "Customers" -Object $object
    #>
    param(
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $TableName,
        [Parameter(Mandatory = $true)]
        [object]$Object
    )

    #* Private function
    #region 
    
    function ConvertTo-SQLType {
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

    #endregion


    $properties = $Object | Get-Member | Where-Object MemberType -EQ "noteProperty"
    $columns = $properties | ForEach-Object { $_.Name }
    
    $Values = $Object | ForEach-Object {
        
        $TempObject = $null
        $TempObject = $_
        
        $Combine = $null
        $Combine = $properties | ForEach-Object {
            (ConvertTo-SQLType $TempObject.$($_.Name))
        }
        "`n($($Combine -join ","))"
        
    }

    if ($Values.count -gt 999) {
        throw "The number of records is greater than 999"
    }
    
    return "INSERT INTO $TableName ($($columns -join ',')) VALUES $($Values -join ",");"
    
}