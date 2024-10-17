function hailstone(n: Integer): sequence of integer;
begin
  result := seq(n);
  while n > 1 do
  begin
    n := n.IsEven ? n div 2 : 3 * n + 1;
    result := result + seq(n);
  end;
end;

begin
  var a := hailstone(27);
  println(a.Count, a.Take(4), a.TakeLast(4));
  var max := 0;
  var maxi := 0;
  for var i := 1 to 100_000 do
    if hailstone(i).Count > max then
    begin
      max := hailstone(i).Count;
      maxi := i;
    end;
  println(maxi, max);
end.
