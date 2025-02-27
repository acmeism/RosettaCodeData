function derangements<T>(a: array of T) :=
    a.Permutations.where(p -> p.where((x, i) -> x = a[i]).Count = 0);

function subFactorial(n: integer): int64;
begin
  if n <= 1 then result := 1 - n
  else result := (n - 1) * (subfactorial(n - 1) + subfactorial(n - 2));
end;

begin
  println('Derangements of 1 2 3 4:');
  foreach var d in derangements(|1, 2, 3, 4|) do
    d.println;

  println(#10, 'Number of derangements:');
  println('n   counted   calculated');
  println('-   -------   ----------');
  for var n := 1 to 10 do
    writeln(n:2, derangements(range(1, n).ToArray).count:9, subfactorial(n):10);

  println;
    println('!20 = ', subfactorial(20));
end.
