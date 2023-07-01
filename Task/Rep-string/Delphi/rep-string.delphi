program Rep_string;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

const
  m =   '1001110011'#10 +
        '1110111011'#10 +
        '0010010010'#10 +
        '1010101010'#10 +
        '1111111111'#10 +
        '0100101101'#10 +
        '0100100'#10 +
        '101'#10 +
        '11'#10 +
        '00'#10 +
        '1';

function Rep(s: string; var sub:string): Integer;
var
  x: Integer;
begin
  for x := s.Length div 2 downto 1 do
  begin
    sub :=  s.Substring(x);
    if s.StartsWith(sub) then
      exit(x);
  end;
  sub := '';
  Result := 0;
end;

begin
  for var s in m.Split([#10]) do
  begin
    var sub := '';
    var n := rep(s,sub);
    if n > 0 then
      writeln(format('"%s"  %d rep-string "%s"', [s, n, sub]))
    else
      writeln(format('"%s"  not a rep-string', [s]));
  end;
  {$IFNDEF UNIX}readln;{$ENDIF}
end.
