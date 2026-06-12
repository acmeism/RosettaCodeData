program Find_words_which_contains_all_the_vowels;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IoUtils;

function IsVowelsOnce(w: string): Boolean;
const
  chars: array[0..4] of char = ('a', 'e', 'i', 'o', 'u');
var
  cs: array[0..4] of Boolean;
  i: Integer;
  c: char;
begin
  if w.IsEmpty then
    exit(false);

  FillChar(cs, length(cs), 0);

  for c in w do
  begin
    for i := 0 to 4 do
    begin
      if c = chars[i] then
      begin
        if cs[i] then
          exit(false);
        cs[i] := True;
      end;
    end;
  end;

  for i := 0 to 4 do
    if not cs[i] then
      exit(False);
  Result := True;
end;

begin
  var Lines := TFile.ReadAllLines('unixdict.txt');
  var count := 0;
  for var Line in Lines do
    if IsVowelsOnce(Line) and (Line.length > 10) then
    begin
      inc(count);
      Writeln(count: 2, ': ', Line);
    end;

  readln;
end.
