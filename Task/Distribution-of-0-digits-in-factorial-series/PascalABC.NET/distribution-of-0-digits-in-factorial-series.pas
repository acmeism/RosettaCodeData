##
var fact := 1bi;
var sum := 0.0;
println('The mean proportion of zero digits in factorials up to the following are:');
for var n := 1 to 10_000 do
begin
  fact *= n;
  var factstr := fact.toString;
  var zeros  := factstr.count(x -> x = '0');
  sum := sum + zeros / factstr.length;
  if n in |100, 1000, 10000| then
    writeln(n:5, sum / n:20);
end;
