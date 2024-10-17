program Determine_if_a_string_has_all_the_same_characters;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

procedure Analyze(s: string);
var
  b, c: char;
  i: Integer;
begin
  writeln(format('Examining [%s] which has a length of %d:', [s, s.Length]));
  if s.Length > 1 then
  begin
    b := s[1];
    for i := 2 to s.Length - 1 do
    begin
      c := s[i];
      if c <> b then
      begin
        writeln('    Not all characters in the string are the same.');
        writeln(format('    "%s" 0x%x is different at position %d', [c, Ord(c), i]));
        Exit;
      end;
    end;
  end;
  writeln('    All characters in the string are the same.');
end;

var
  TestCases: array of string = ['', '   ', '2', '333', '.55', 'tttTTT', '4444 444k'];
  w: string;

begin
  for w in TestCases do
    Analyze(w);
  Readln;
end.
