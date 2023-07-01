program MultiplicationTables;

{$APPTYPE CONSOLE}

uses SysUtils;

const
  MAX_COUNT = 12;
var
  lRow, lCol: Integer;
begin
  Write('  | ');
  for lRow := 1 to MAX_COUNT do
    Write(Format('%4d', [lRow]));
  Writeln('');
  Writeln('--+-' + StringOfChar('-', MAX_COUNT * 4));
  for lRow := 1 to MAX_COUNT do
  begin
    Write(Format('%2d', [lRow]));
    Write('| ');
    for lCol := 1 to MAX_COUNT do
    begin
      if lCol < lRow then
        Write('    ')
      else
        Write(Format('%4d', [lRow * lCol]));
    end;
    Writeln;
  end;
end.
