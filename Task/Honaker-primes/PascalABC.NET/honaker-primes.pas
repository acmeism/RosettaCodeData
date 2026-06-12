function gen_primes: sequence of integer;
begin
  yield 2;
  var D := new Dictionary<integer, integer>;
  var q := 3;
  while True do
  begin
    if q not in D then
    begin
      if q < maxint.Sqrt.Floor then
        D[q * q] := q;
      yield q;
    end
    else
    begin
      var p := D[q];
      D -= q;
      var x := q + p + p;
      while x in D do x += p + p;
      D[x] := p;
    end;
    q += 2;
  end;
end;

function digitalsum(n: integer) := n.ToString.select(x -> x.ToDigit).Sum;

function honakerPrimes: sequence of (integer, integer);
begin
  foreach var n in gen_primes index i do
    if digitalSum(i + 1) = digitalSum(n) then
      yield (i + 1, n)
end;

begin
  writeln('First 50 Honaker primes (index, prime):');
  foreach var p in honakerPrimes index i do
  begin
    write(p:11);
    if (i + 1) mod 5 = 0 then println;
    if i = 49 then break;
  end;
  println;
  print('Ten thousandth:');
  honakerPrimes.ElementAt(10_000 - 1).Println;
end.
