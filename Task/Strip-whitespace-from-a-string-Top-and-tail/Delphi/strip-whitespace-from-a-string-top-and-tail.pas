program StripWhitespace;

{$APPTYPE CONSOLE}

uses SysUtils;

const
  TEST_STRING = '     String with spaces     ';
begin
  Writeln('"' + TEST_STRING + '"');
  Writeln('"' + TrimLeft(TEST_STRING) + '"');
  Writeln('"' + TrimRight(TEST_STRING) + '"');
  Writeln('"' + Trim(TEST_STRING) + '"');
end.
