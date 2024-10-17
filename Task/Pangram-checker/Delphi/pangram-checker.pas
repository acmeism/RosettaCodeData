program PangramChecker;

{$APPTYPE CONSOLE}

uses StrUtils;

function IsPangram(const aString: string): Boolean;
var
  c: char;
begin
  for c := 'a' to 'z' do
    if not ContainsText(aString, c) then
      Exit(False);

  Result := True;
end;

begin
  Writeln(IsPangram('The quick brown fox jumps over the lazy dog')); // true
  Writeln(IsPangram('Not a panagram')); // false
end.
