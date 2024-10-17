procedure hist(numbers: array of real);
begin
  var h := arrfill(10, 0);
  foreach var n in numbers do h[floor(10 * n)] += 1;
  for var i := 0 to 9 do
    Writeln(i / 10:1:1, '+  ', '+' * floor(h[i] / h.Max * 50));
end;

begin
  foreach var n in |100, 1_000, 10_000, 1_000_000| do
  begin
    var numbers := ArrRandomReal(n, 0, 1, 10);
    var mean := numbers.Average;
    var std := numbers.Sum(x -> Sqr(x - mean) / n).Sqrt;
    println('numbers:', n, 'mean:', mean, 'stddev:', std);
    hist(numbers);
    Println;
  end;
end.
