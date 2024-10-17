program Rot13;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function Rot13char(c: AnsiChar): AnsiChar;
begin
  Result := c;
  if c in ['a'..'m', 'A'..'M'] then
    Result := AnsiChar(ord(c) + 13)
  else if c in ['n'..'z', 'N'..'Z'] then
    Result := AnsiChar(ord(c) - 13);
end;

function Rot13Fn(s: ansistring): ansistring;
var i: Integer;
begin
  SetLength(result, length(s));
  for i := 1 to length(s) do
    Result[i] := Rot13char(s[i]);
end;

begin
  writeln(Rot13Fn('nowhere ABJURER'));
  readln;
end.
