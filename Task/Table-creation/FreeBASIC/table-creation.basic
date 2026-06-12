#include once "sqlite3.bi"

Const NULL As Any Ptr = 0

Dim As sqlite3 Ptr db
Dim As zstring Ptr errMsg
Dim As sqlite3_stmt Ptr stmt

If sqlite3_open(":memory:", @db) <> SQLITE_OK Then
    Print "Could not open database: "; sqlite3_errmsg(db)
    sqlite3_close(db)
    Sleep
    End 1
End If

' Create the table
Dim As String sql = "CREATE TABLE Persons(" _
& "ID INT PRIMARY KEY     NOT NULL," _
& "NAME           TEXT    NOT NULL," _
& "SURNAME        TEXT    NOT NULL," _
& "AGE            INT     NOT NULL," _
& "ADDRESS        CHAR(50)," _
& "SALARY         REAL );"

If sqlite3_exec(db, sql, NULL, NULL, @errMsg) <> SQLITE_OK Then
    Print "Error creating table: "; *errMsg
    sqlite3_free(errMsg)
Else
    Print "Table created successfully"
End If

' Insert some data
sql = "INSERT INTO Persons (ID, NAME, SURNAME, AGE, ADDRESS, SALARY) " _
& "VALUES (1, 'John', 'Doe', 30, '123 Main St', 50000.00);"

If sqlite3_exec(db, sql, NULL, NULL, @errMsg) <> SQLITE_OK Then
    Print "Error inserting data: "; *errMsg
    sqlite3_free(errMsg)
End If

' Display the contents of the table
sql = "SELECT * FROM Persons;"

If sqlite3_prepare_v2(db, sql, -1, @stmt, NULL) <> SQLITE_OK Then
    Print "Error preparing statement: "; sqlite3_errmsg(db)
Else
    While sqlite3_step(stmt) = SQLITE_ROW
        Print "ID: "; sqlite3_column_int(stmt, 0)
        Print "Name: "; *cast(zstring ptr, sqlite3_column_text(stmt, 1))
        Print "Surname: "; *cast(zstring ptr, sqlite3_column_text(stmt, 2))
        Print "Age: "; sqlite3_column_int(stmt, 3)
        Print "Address: "; *cast(zstring ptr, sqlite3_column_text(stmt, 4))
        Print "Salary: "; sqlite3_column_double(stmt, 5)
        Print
    Wend
End If

sqlite3_finalize(stmt)
sqlite3_close(db)

Sleep
