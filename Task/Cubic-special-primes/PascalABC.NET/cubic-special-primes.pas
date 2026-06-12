uses School;
begin
  var cubes := new List<integer>();
  for var i := 0 to 25 do
    cubes.Add(i * i * i);

  var lastPrime := 2;
  var limit := 16000;
  var primes := Primes(limit);

  foreach var g in primes do
    if cubes.Contains(g - lastPrime) then
    begin
      lastPrime := g;
      write(g, ' ');
    end;
end.
