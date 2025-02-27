function digitsum(n: integer) := n.ToString.Select(c -> c.ToDigit).Sum;

function a131382(): sequence of integer;
begin
  foreach var n in 1.step do
  begin
    var m := 1;
    while digitsum(m * n) <> n do m += 1;
    yield m;
  end;
end;

begin
  foreach var n in a131382.take(70) index i do
    write(n:9, if i mod 10 = 9 then #10 else '');
end.
