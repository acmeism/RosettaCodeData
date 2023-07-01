program Parametrized_SQL_Statement;
uses
  sqlite3, sysutils;

const
  DB_FILE : PChar = ':memory:'; // Create an in-memory database.

var
  DB                :Psqlite3;
  ResultCode        :Integer;
  SQL               :PChar;
  InsertStatements  :array [1..4] of PChar;
  CompiledStatement :Psqlite3_stmt;
  i                 :integer;

{ CheckError

  Checks the result code from an SQLite operation.
  If it contains an error code then this procedure prints the error message,
  closes the database and halts the program. }

procedure CheckError(ResultCode: integer; DB: Psqlite3);
begin
  if ResultCode <> SQLITE_OK then
  begin
    writeln(format('Error #%d: %s', [ResultCode, sqlite3_errmsg(db)]));
    sqlite3_close(DB);
    halt(ResultCode);
  end;
end;

{ SelectCallback

  This callback function prints the results of the select statement.}

function SelectCallback(Data: pointer; ColumnCount: longint; Columns: PPChar; ColumnNames: PPChar):longint; cdecl;
var
  i   :longint;
  col :PPChar;
begin
  col := Columns;
  for i:=0 to ColumnCount-1 do
  begin
    write(col^); // Print the current column value.
    inc(col);    // Advance the pointer.
    if i<>ColumnCount-1 then write(' | ');
  end;
  writeln;
end;

begin
  // Open the database.
  ResultCode := sqlite3_open(DB_FILE, @DB);
  CheckError(ResultCode, DB);

  // Create the players table in the database.
  SQL := 'create table players(' +
         'id integer primary key asc, ' +
         'name text, ' +
         'score real, ' +
         'active integer, ' + // Store the bool value as integer (see https://sqlite.org/datatype3.html chapter 2.1).
         'jerseyNum integer);';
  ResultCode := sqlite3_exec(DB, SQL, nil, nil, nil);
  CheckError(ResultCode, DB);

  // Insert some values into the players table.
  InsertStatements[1] := 'insert into players (name, score, active, jerseyNum) ' +
                                      'values (''Roethlisberger, Ben'', 94.1, 1, 7);';
  InsertStatements[2] := 'insert into players (name, score, active, jerseyNum) ' +
                                      'values (''Smith, Alex'', 85.3, 1, 11);';
  InsertStatements[3] := 'insert into players (name, score, active, jerseyNum) ' +
                                      'values (''Manning, Payton'', 96.5, 0, 18);';
  InsertStatements[4] := 'insert into players (name, score, active, jerseyNum) ' +
                                      'values (''Doe, John'', 15, 0, 99);';

  for i:=1 to 4 do
  begin
    ResultCode := sqlite3_exec(DB, InsertStatements[i], nil, nil, nil);
    CheckError(ResultCode, DB);
  end;

  // Display the contents of the players table.
  writeln('Before update:');
  SQL := 'select * from players;';
  ResultCode := sqlite3_exec(DB, SQL, @SelectCallback, nil, nil);
  CheckError(ResultCode, DB);

  // Prepare the parametrized SQL statement to update player #99.
  SQL := 'update players set name=?, score=?, active=? where jerseyNum=?;';
  ResultCode := sqlite3_prepare_v2(DB, SQL, -1, @CompiledStatement, nil);
  CheckError(ResultCode, DB);

  // Bind the values to the parameters (see https://sqlite.org/c3ref/bind_blob.html).
  ResultCode := sqlite3_bind_text(CompiledStatement, 1, PChar('Smith, Steve'), -1, nil);
  CheckError(ResultCode, DB);
  ResultCode := sqlite3_bind_double(CompiledStatement, 2, 42);
  CheckError(ResultCode, DB);
  ResultCode := sqlite3_bind_int(CompiledStatement, 3, 1);
  CheckError(ResultCode, DB);
  ResultCode := sqlite3_bind_int(CompiledStatement, 4, 99);
  CheckError(ResultCode, DB);

  // Evaluate the prepared SQL statement.
  ResultCode := sqlite3_step(CompiledStatement);
  if ResultCode <> SQLITE_DONE then
  begin
    writeln(format('Error #%d: %s', [ResultCode, sqlite3_errmsg(db)]));
    sqlite3_close(DB);
    halt(ResultCode);
  end;

  // Destroy the prepared statement object.
  ResultCode := sqlite3_finalize(CompiledStatement);
  CheckError(ResultCode, DB);

  // Display the contents of the players table.
  writeln('After update:');
  SQL := 'select * from players;';
  ResultCode := sqlite3_exec(DB, SQL, @SelectCallback, nil, nil);
  CheckError(ResultCode, DB);

  // Close the database connection.
  sqlite3_close(db);
end.
