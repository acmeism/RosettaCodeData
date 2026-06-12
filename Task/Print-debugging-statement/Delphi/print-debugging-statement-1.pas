program DebugApp;

{$APPTYPE CONSOLE}

uses
  winapi.windows,
  System.sysutils;

function Add(x, y: Integer): Integer;
begin
  Result := x + y;
  OutputDebugString(PChar(format('%d + %d = %d', [x, y, result])));
end;

begin
  writeln(Add(2, 7));
  readln;
end.
