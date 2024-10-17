function countdiv(n: integer): integer;
begin
  result := Range(1, n.Sqrt.Trunc).Count(x -> n mod x = 0) * 2;
  if n.Sqrt.Round.sqr = n then result -= 1;
end;

function AntiPrimes(): sequence of integer;
begin
  var maxDiv := 0;
  var i := 1;
  while True do
  begin
    var d := countdiv(i);
    if d > maxDiv then
    begin
      yield i;
      maxDiv := d;
    end;
    i += 1;
  end;
end;

begin
  AntiPrimes.Take(20).Println;
  println;
  AntiPrimes.Take(40).Println;
end.
