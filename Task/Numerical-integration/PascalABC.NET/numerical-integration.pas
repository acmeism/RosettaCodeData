function integrate(a, b: real; n: integer; f: real-> real): real;
begin
  var h := (b - a) / n;
  var sum: array [0..4] of real;
  for var i := 0 to n - 1 do
  begin
    var x := a + i * h;
    sum[0] += f(x);
    sum[1] += f(x + h / 2.0);
    sum[2] += f(x + h);
    sum[3] += (f(x) + f(x + h)) / 2.0;
    sum[4] += (f(x) + 4.0 * f(x + h / 2.0) + f(x + h)) / 6.0;
  end;
  var methods := |'LeftRect ', 'MidRect  ', 'RightRect', 'Trapezium', 'Simpson  '|.tolist;
  for var i := 0 to 4 do
    println(methods[i], ' = ', sum[i] * h);
  println;
end;

begin
  integrate(0.0, 1.0, 100, x -> x * x * x);
  integrate(1.0, 100.0, 1_000, x -> 1 / x);
  integrate(0.0, 5000.0, 5_000_000, x -> x);
  integrate(0.0, 6000.0, 6_000_000, x -> x);
end.
