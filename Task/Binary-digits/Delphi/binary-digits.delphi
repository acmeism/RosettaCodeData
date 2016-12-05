program BinaryDigit;
{$APPTYPE CONSOLE}
uses
  sysutils;

function IntToBinStr(AInt : LongWord) : string;
begin
  Result := '';
  repeat
    Result := Chr(Ord('0')+(AInt and 1))+Result;
    AInt := AInt div 2;
  until (AInt = 0);
end;

Begin
  writeln('   5: ',IntToBinStr(5));
  writeln('  50: ',IntToBinStr(50));
  writeln('9000: '+IntToBinStr(9000));
end.
