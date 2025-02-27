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

function period(n: integer): integer;
begin
  var r := 1;
  repeat
    r := r * 10 mod n;
    result += 1;
  until r <= 1;
end;

begin
  writeln('The long primes up to 500 are:');
  var primes := Gen_primes_upto(64000).Skip(1);
  primes.Where(x -> (x < 500) and (period(x) = x - 1)).Println;
  writeln;

  writeln('The number of long primes up to:');
  foreach var n in |500, 1000, 2000, 4000, 8000, 16000, 32000, 64000| do
    writeln(n:6, ' is ', primes.Where(x -> (x < n) and (period(x) = x - 1)).Count);
end.
