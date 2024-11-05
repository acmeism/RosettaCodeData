const
  maxi = maxint.Sqrt.Floor;

function gen_primes: sequence of integer;
begin
  yield 2;
  var D := new Dictionary<integer, integer>;
  var q := 3;
  while True do
  begin
    if q not in D then
    begin
      if q < maxi then // prevent overflow
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

function reverse(n: integer) := strtoint(reversestring(n.ToString));

function gen_emirp: sequence of integer;
begin
  var decimals := 2;
  while true do
  begin
    var primes := gen_primes.SkipWhile(x -> x < 10 ** (decimals - 1))
                            .TakeWhile(x -> x < 10 ** decimals)
                            .ToHashSet;
    foreach var prime in primes do
    begin
      var revprime := reverse(prime);
      if (revprime <> prime) and primes.Contains(revprime) then yield (prime);
    end;
    decimals += 1;
  end;
end;

begin
  println('The first 20 emirps are:');
  gen_emirp.Take(20).Println;
  println;
  println('The emirps between 7700 and 8000 are:');
  gen_emirp.SkipWhile(p -> p < 7700).TakeWhile(p -> p < 8000).println;
  println;
  print('The 10,000th emirp is');
  gen_emirp.Skip(10_000 - 1).First.Println;
end.
