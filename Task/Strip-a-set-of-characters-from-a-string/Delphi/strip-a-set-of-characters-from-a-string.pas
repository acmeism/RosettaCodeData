program StripCharacters;

{$APPTYPE CONSOLE}

uses SysUtils;

function StripChars(const aSrc, aCharsToStrip: string): string;
var
  c: Char;
begin
  Result := aSrc;
  for c in aCharsToStrip do
    Result := StringReplace(Result, c, '', [rfReplaceAll, rfIgnoreCase]);
end;

const
  TEST_STRING = 'She was a soul stripper. She took my heart!';
begin
  Writeln(TEST_STRING);
  Writeln(StripChars(TEST_STRING, 'aei'));
end.
