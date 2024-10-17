program IncrementNumericalString;

{$APPTYPE CONSOLE}

uses SysUtils;

const
  STRING_VALUE = '12345';
begin
  WriteLn(Format('"%s" + 1 = %d', [STRING_VALUE, StrToInt(STRING_VALUE) + 1]));

  Readln;
end.
