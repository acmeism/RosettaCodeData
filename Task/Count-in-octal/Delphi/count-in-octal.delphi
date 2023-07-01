program CountingInOctal;

{$APPTYPE CONSOLE}

uses SysUtils;

function DecToOct(aValue: Integer): string;
var
  lRemainder: Integer;
begin
  Result := '';
  repeat
    lRemainder := aValue mod 8;
    Result := IntToStr(lRemainder) + Result;
    aValue := aValue div 8;
  until aValue = 0;
end;

var
  i: Integer;
begin
  for i := 0 to 20 do
    WriteLn(DecToOct(i));
end.
