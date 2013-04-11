program TokenizeString;

{$mode objfpc}{$H+}

const
  CHelloStr = 'Hello,How,Are,You,Today';
var
  I: Integer;
  VResult: string = '';
begin
  for I := 1 to Length(CHelloStr) do
    if CHelloStr[I] = ',' then
      VResult += LineEnding
    else
      VResult += CHelloStr[I];
  WriteLn(VResult);
end.
