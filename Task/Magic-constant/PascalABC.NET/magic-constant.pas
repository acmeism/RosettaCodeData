##
function magic(n: biginteger) := n * (n * n + 1) div 2;

println('The first 20 magic constants:');
(1 + 2..22).Select(x -> magic(x)).Println;
println;

println('The 1,000th magic constant:',magic(1000 + 2),#10);

for var n := 1 to 20 do
begin
  write('10^', n, ': ');
  (1..maxint).Select(x -> biginteger(x))
             .SkipWhile(x -> magic(x) < power(10bi, n))
             .First
             .Println;
end;
