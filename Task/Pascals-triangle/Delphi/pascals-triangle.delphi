program PascalsTriangle;

procedure Pascal(r:Integer);
var
  i, c, k:Integer;
begin
  for i := 0 to r - 1 do
  begin
    c := 1;
    for k := 0 to i do
    begin
      Write(c:3);
      c := c * (i - k) div (k + 1);
    end;
    Writeln;
  end;
end;

begin
  Pascal(9);
end.
