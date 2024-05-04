


Describe "ConvertTo-SQLInsert" {
    
    BeforeAll {
        . ".\Src\Public\ConvertTo-SQLInsert.ps1"
        . ".\Src\Private\ConvertTo-SQLType.ps1"
    }
    
    Context "When converting an object to a SQL INSERT statement" {
        It "Returns the correct SQL INSERT statement" {
            # Arrange
            $tableName = "Customers"
            $object = [PSCustomObject]@{
                Name   = "John"
                Age    = 30
                Active = $true
            }

            # Act
            $result = ConvertTo-SQLInsert -TableName $tableName -Object $object

            # Assert
            $expectedStatement = "INSERT INTO $tableName (Active,Age,Name) VALUES `n('1','30','John');"
            $result | Should -Be $expectedStatement
        }

        It "Throws an error if the number of records is greater than 999" {
            # Arrange
            $tableName = "Customers"
            $object = 1..1000 | ForEach-Object {
                [PSCustomObject]@{
                    Name      = "John$_"
                    Age       = $_
                    BirthDate = Get-Date
                    Active    = $true
                }
            }

            # Act & Assert
            { ConvertTo-SQLInsert -TableName $tableName -Object $object } | Should -Throw "The number of records is greater than 999"
        }
    }
}
