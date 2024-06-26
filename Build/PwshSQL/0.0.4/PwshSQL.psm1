#
# Modulefile for module 'PwshSQL'
#
# Generated by: Jack den Ouden
#
# Generated on: 05/05/2024 11:00:47
#


#* ConvertTo-SQLType
#region

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
        
        If the value is $null it will return "NULL".
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
        [Parameter()]
        [AllowEmptyString()]
        [object]$value
    )

    if ($value -eq $null) {
        return "NULL"
    }
    switch ($value.GetType().FullName) {
        "System.String" {
            "'$($value.Replace("'", "''"))'"
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
            "'$($value.ToString().Replace("'", "''"))'"
        }
    }
}

#endregion
 
#* ConvertTo-SQLInsert
#region

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

#endregion
 
#* Invoke-SQLInsert
#region



#endregion
 
#* Split-PSObject
#region

Function Split-PSObject {
    <#
    .SYNOPSIS
        Splits a PSCustomObject into groups of a specified size.
    .DESCRIPTION
        Splits a PSCustomObject into groups of a specified size.
    .PARAMETER InputObject
        The PSCustomObject to split.
    .PARAMETER SplitSize    
        The size of the groups to split the PSCustomObject into.
    .NOTES
        File Name      : Split-PSObject.ps1
        Author         : Jack den Ouden
        Change history : 
            2024-05-04 - Initial creation
    .LINK
        https://github.com/Jackldam/PwshSQL
    .EXAMPLE
        $Object | Split-PSObject -splitSize 50
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSCustomObject]$InputObject,
        [int]$SplitSize
    )

    begin {
        $Consolidation = @()
        $FirstLoop = $true
        $Start = 0
    }

    process {
        $Consolidation += $InputObject
    }

    end {

        $Groups = [math]::Ceiling($Consolidation.count / $SplitSize) - 1
        
        0..$Groups | ForEach-Object {

            if ($FirstLoop) {
                $Start = 0
                $End = $SplitSize
                $FirstLoop = $false
            }
            else {
                $Start = $End + 1
                $End = $End + $SplitSize
                # Ensure $End does not exceed the last index of $Consolidation
                if ($End -gt $Consolidation.count) {
                    $End = $Consolidation.count
                }
            }

            if ($($Consolidation[$Start..$End])) {
                [PSCustomObject]@{
                    Group  = $_
                    Object = $Consolidation[$Start..$End]
                }
            }
        }

    }
}



#endregion
