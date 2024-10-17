program UserInputText;

{$APPTYPE CONSOLE}

uses SysUtils;

var
  s: string;
  lStringValue: string;
  lIntegerValue: Integer;
begin
  WriteLn('Enter a string:');
  Readln(lStringValue);

  repeat
    WriteLn('Enter the number 75000');
    Readln(s);
    lIntegerValue := StrToIntDef(s, 0);
    if lIntegerValue <> 75000 then
      Writeln('Invalid entry: ' + s);
  until lIntegerValue = 75000;
end.
