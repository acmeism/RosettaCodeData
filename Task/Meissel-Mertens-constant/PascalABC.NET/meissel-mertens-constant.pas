function gen_primes_upto(n: integer): sequence of integer;
begin
  if n < 3 then exit;
  var table := |True| * n;
  var sqrtn := n.sqrt.Floor;
  for var i := 2 to sqrtn do
    if table[i] then
      for var j := i * i to n - 1 step i do
        table[j] := False;

  yield 2;
  for var i := 3 to n step 2 do
    if table[i] then yield i
end;

begin
  var γ := 0.57721566490153286;
  var sum := 0.0;
  foreach var p in gen_primes_upto(10_000_000_000) index i do
  begin
    var rp := 1 / p;
    sum += ln(1 - rp) + rp;
    //  inc count
    if (i+1) mod 10_000_000 = 0 then
      writeln(i+1, sum + γ:20);
  end;
end.
