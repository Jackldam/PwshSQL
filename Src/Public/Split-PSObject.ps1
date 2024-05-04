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

