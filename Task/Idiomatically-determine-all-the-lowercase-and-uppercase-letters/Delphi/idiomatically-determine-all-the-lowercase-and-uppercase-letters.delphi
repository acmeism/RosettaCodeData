program Idiomatically_determine_all_the_lowercase_and_uppercase_letters;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Character;

begin
  var count := 0;
  Write('Upper case: ');
  for var i := 0 to $10FFFF do
    if char(i).IsUpper then
    begin
      write(char(i));
      inc(count);
      if count >= 72 then
        Break;
    end;
  writeln('...');

  count := 0;
  Write('Lower case: ');
  for var i := 0 to $10FFFF do
    if char(i).IsLower then
    begin
      write(char(i));
      inc(count);
      if count >= 72 then
        Break;
    end;
  writeln('...');
  readln;
end.
