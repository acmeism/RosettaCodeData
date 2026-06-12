program Remove_vowels_from_a_string;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

function RemoveVowels(const s: string): string;
const
  VOWELS =['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'];
var
  c: char;
begin
  Result := '';
  for c in s do
  begin
    if not (c in VOWELS) then
      Result := Result + c;
  end;
end;

const
  TEST = 'The quick brown fox jumps over the lazy dog';

begin
  Writeln('Before: ', TEST);
  Writeln('After:  ', RemoveVowels(TEST));
  Readln;
end.

