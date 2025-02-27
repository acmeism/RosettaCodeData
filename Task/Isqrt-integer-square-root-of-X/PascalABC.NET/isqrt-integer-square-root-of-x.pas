function isqrt(x: biginteger): biginteger;
begin
  var q := 1bi;
  result := 0bi;
  while q <= x do
    q := q shl 2;
  while q > 1 do
  begin
    q := q shr 2;
    var t := x - result - q;
    result := result shr 1;
    if t >= 0 Then
    begin
      x := t;
      result += q;
    end;
  end;
end;

begin
  for var n := 0 to 65 do
    write(isqrt(n):2);
  println(#10);
  var n := 7bi;
  for var i := 1 to 73 step 2 do
  begin
    writeln('isqrt(7^', i, ') = ', isqrt(n).ToString('N0'));
    n *= 49;
  end;
end.
