Describe "ConvertTo-SQLType" {
    BeforeAll {
        . ".\Src\Private\ConvertTo-SQLType.ps1"
    }

    It "Converts a string to a SQL type" {
        $result = ConvertTo-SQLType -value "Hello World"
        $result | Should -Be "'Hello World'"
    }
    It "Converts an integer to a SQL type" {
        $result = ConvertTo-SQLType -value 30
        $result | Should -Be "'30'"
    }
    It "Converts a datetime to a SQL type" {
        $result = ConvertTo-SQLType -value (Get-Date)
        $result | Should -Be ("'" + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") + "'")
    }
    It "Converts a boolean to a SQL type" {
        $result = ConvertTo-SQLType -value $true
        $result | Should -Be "'1'"
    }
    It "Converts a boolean to a SQL type" {
        $result = ConvertTo-SQLType -value $false
        $result | Should -Be "'0'"
    }
    It "Converts a null to a SQL type" {
        $result = ConvertTo-SQLType -value $null
        $result | Should -Be "NULL"
    }
}