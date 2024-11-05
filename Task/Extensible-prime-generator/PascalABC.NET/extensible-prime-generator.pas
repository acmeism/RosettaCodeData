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

begin
  print('The first 20 primes are:');
  gen_primes.Take(20).println;
  print('The primes between 100 and 150 are:');
  gen_primes.SkipWhile(x -> x < 100).TakeWhile(x -> x < 150).Println;
  print('The number of primes between 7700 and 8000 is:');
  gen_primes.SkipWhile(x -> x < 7700).TakeWhile(x -> x < 8000).count.Println;
  print('The 10,000th prime is:');
  gen_primes.Skip(10_000 - 1).First.Println;
  print('The 100,000,000th prime is:');
  gen_primes.Skip(100_000_000 - 1).First.Println;
  print('The sum of the primes to two million is:');
  gen_primes.Takewhile(x -> x < 2_000_000).select(x -> int64(x)).Sum.Println;
end.
