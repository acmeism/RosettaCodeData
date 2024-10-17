program Empty_directory;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils;

function IsDirectoryEmpty(dir: string): Boolean;
var
  count: Integer;
begin
  count := Length(TDirectory.GetFiles(dir)) + Length(TDirectory.GetDirectories(dir));
  Result := count = 0;
end;

var
  i: Integer;

const
  CHECK: array[Boolean] of string = (' is not', ' is');

begin
  if ParamCount > 0 then
    for i := 1 to ParamCount do
      Writeln(ParamStr(i), CHECK[IsDirectoryEmpty(ParamStr(i))], ' empty');
  Readln;
end.
