program Multisplit;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

begin
  write('[');
  for var s in 'a!===b=!=c'.Split(['==', '!=', '=']) do
    write(s.QuotedString('"'), ' ');
  write(']');
  readln;
end.
