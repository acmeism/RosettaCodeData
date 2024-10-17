program EnvironmentVariable;

{$APPTYPE CONSOLE}

uses SysUtils;

begin
  WriteLn('Temp = ' + GetEnvironmentVariable('TEMP'));
end.
