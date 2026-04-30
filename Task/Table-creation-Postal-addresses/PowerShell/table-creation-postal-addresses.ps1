Import-Module -Name PSSQLite


## Create a database and a table
$dataSource = ".\Addresses.db"
$query = "CREATE TABLE SSADDRESS (Id        INTEGER  PRIMARY KEY  AUTOINCREMENT,
                                  LastName  TEXT     NOT NULL,
                                  FirstName TEXT     NOT NULL,
                                  Address   TEXT     NOT NULL,
                                  City      TEXT     NOT NULL,
                                  State     CHAR(2)  NOT NULL,
                                  Zip       CHAR(5)  NOT NULL
)"

Invoke-SqliteQuery -Query $Query -DataSource $DataSource


## Insert some data
$query = "INSERT INTO SSADDRESS ( FirstName,  LastName,  Address,  City,  State,  Zip)
                         VALUES (@FirstName, @LastName, @Address, @City, @State, @Zip)"

Invoke-SqliteQuery -DataSource $DataSource -Query $query -SqlParameters @{
        LastName  = "Monster"
        FirstName = "Cookie"
        Address   = "666 Sesame St"
        City      = "Holywood"
        State     = "CA"
        Zip       = "90013"
}


## View the data
Invoke-SqliteQuery -DataSource $DataSource -Query "SELECT * FROM SSADDRESS" | FormatTable -AutoSize
