program Menu;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function ChooseMenu(Options: TArray<string>; Prompt: string): string;
var
  index: Integer;
  value: string;
begin
  if Length(Options) = 0 then
    exit('');
  repeat
    writeln;
    for var i := 0 to length(Options) - 1 do
      writeln(i + 1, '. ', Options[i]);
    write(#10, Prompt, ' ');
    Readln(value);
    index := StrToIntDef(value, -1);
  until (index > 0) and (index <= length(Options));
  Result := Options[index];
end;

begin
  writeln('You picked ', ChooseMenu(['fee fie', 'huff and puff', 'mirror mirror',
    'tick tock'], 'Enter number: '));
  readln;
end.
