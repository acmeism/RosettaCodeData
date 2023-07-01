program LookAndSayDemo(input, output);

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

uses
  SysUtils;

function LookAndSay(s: string): string;
var
  item: char;
  index: integer;
  count: integer;
begin
  Result := '';
  item := s[1];
  count := 1;
  for index := 2 to length(s) do
    if item = s[index] then
      inc(count)
    else
    begin
      Result := Result + intTostr(count) + item;
      item := s[index];
      count := 1;
    end;
  Result := Result + intTostr(count) + item;
end;

var
  number: string;

begin
  writeln('Press RETURN to continue and ^C to stop.');
  number := '1';
  while not eof(input) do
  begin
   write(number);
   readln;
   number := LookAndSay(number);
  end;
end.
