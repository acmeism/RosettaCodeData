#include once "sqlite3.bi"

Const NULL As Any Ptr = 0

Dim As sqlite3 Ptr db
Dim As zstring Ptr errMsg

If sqlite3_open(":memory:", @db) <> SQLITE_OK Then
    Print "Could not open database: "; sqlite3_errmsg(db)
    sqlite3_close(db)
    Sleep
    End 1
End If

Dim As String sql = "CREATE TABLE address(" _
    & "addrID  INTEGER PRIMARY KEY AUTOINCREMENT," _
    & "addrStreet TEXT NOT NULL," _
    & "addrCity   TEXT NOT NULL," _
    & "addrState  TEXT NOT NULL," _
    & "addrZIP    TEXT NOT NULL);"

If sqlite3_exec(db, sql, NULL, NULL, @errMsg) <> SQLITE_OK Then
    Print "Error creating table: "; *errMsg
    sqlite3_free(errMsg)
Else
    Print "Table created successfully"
End If

sqlite3_close(db)

Sleep
