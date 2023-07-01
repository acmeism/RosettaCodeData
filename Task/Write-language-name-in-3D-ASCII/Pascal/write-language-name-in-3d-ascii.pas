program WritePascal;

const
  i64: int64 = 1055120232691680095; (* This defines "Pascal" *)
  cc: array[-1..15] of string = (* Here are all string-constants *)
    ('_______v---',
    '__', '\_', '___', '\__',
    '  ', '  ', '   ', '   ',
    '/ ', '  ', '_/ ', '\/ ',
    ' _', '__', '  _', '  _');
var
  x, y: integer;

begin
  for y := 0 to 7 do
  begin
    Write(StringOfChar(cc[(not y and 1) shl 2][1], 23 - y and 6));
    Write(cc[((i64 shr (y div 2)) and 1) shl 3 + (not y and 1) shl 2 + 2]);
    for x := 0 to 15 do
      Write(cc[((i64 shr ((x and 15) * 4 + y div 2)) and 1) +
        ((i64 shr (((x + 1) and 15) * 4 + y div 2)) and 1) shl 3 +
        (x mod 3) and 2 + (not y and 1) shl 2]);
    writeln(cc[1 + (not y and 1) shl 2] + cc[(not y and 1) shl 3 - 1]);
  end;
end.
