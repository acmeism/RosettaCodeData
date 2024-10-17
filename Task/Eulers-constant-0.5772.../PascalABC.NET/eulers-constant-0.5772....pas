const
  n = 1_000_000;

begin
  var result := 1.0;
  for var i := 2 to n do
    result += 1 / i;
  writeln(result - ln(n));
end.
