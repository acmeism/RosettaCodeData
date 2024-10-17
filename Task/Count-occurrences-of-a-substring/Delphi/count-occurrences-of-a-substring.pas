program OccurrencesOfASubstring;

{$APPTYPE CONSOLE}

uses StrUtils;

function CountSubstring(const aString, aSubstring: string): Integer;
var
  lPosition: Integer;
begin
  Result := 0;
  lPosition := PosEx(aSubstring, aString);
  while lPosition <> 0 do
  begin
    Inc(Result);
    lPosition := PosEx(aSubstring, aString, lPosition + Length(aSubstring));
  end;
end;

begin
  Writeln(CountSubstring('the three truths', 'th'));
  Writeln(CountSubstring('ababababab', 'abab'));
end.
