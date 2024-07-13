function Eratosthenes(N: integer): List<integer>;
type primetype = (nonprime,prime);
begin
  var sieve := |nonprime|*2 + |prime|*(N-1);
  for var i:=2 to N.Sqrt.Round do
    if sieve[i] = prime then
      for var j := i*i to N step i do
        sieve[j] := nonprime;
  Result := new List<integer>;
  for var i:=2 to N do
    if sieve[i] = prime then
      Result.Add(i);
end;

begin
  Eratosthenes(1000).Println
end.
