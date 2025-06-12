function pascal(a, b, mid, top: Integer): (integer, integer, integer);
begin
  var yd := (top - 4 * (a + b)) / 7;
  if yd <> yd.Round then
  begin
    result := (0, 0, 0);
    exit
  end;
  var y  := yd.Round;
  var x  := mid - 2 * a - y;
  result := (x, y, y - x);
end;

begin
  var (x, y, z) := pascal(11, 4, 40, 151);
  if x <> 0 then
    println('Solution: x =', x, 'y =', y, 'z =', z)
  else
    println('There is no solution.')
end.
