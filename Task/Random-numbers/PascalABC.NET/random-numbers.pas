const
  n = 1000;

function randnormal(n: integer; mean, sd: real): array of real;
begin
  var uniform1 := ArrRandomReal(n, 0, 1, 10);
  var uniform2 := ArrRandomReal(n, 0, 1, 10);
  result := uniform1.Zip(uniform2, (x, y) -> Cos(2 * PI * x) * Sqrt(-2 * Ln(y)) * sd + mean).ToArray;
end;

begin
  var numbers := randnormal(n, 1, 0.5);
  var mean := numbers.Average;
  var std := numbers.Sum(x -> Sqr(x - mean) / n).Sqrt;
  println('mean:', mean, 'stddev:', std);
end.
