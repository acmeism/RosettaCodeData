function IsPrime(n: integer): boolean;
begin
  result := false;
  if n < 2 then exit;
  for var i: integer := 2 to round(sqrt(n)) do
    if n mod i = 0 then exit;
  result := true;
end;

function jacobsthalSequence(prev, curr: int64): sequence of int64;
begin
  yield prev;
  yield curr;
  while true do
  begin
    swap(prev, curr);
    curr += curr + prev;
    yield curr;
  end;
end;

function jacobsthalOblong(): sequence of int64;
begin
  var prev := -1;
  foreach var n in jacobsthalSequence(0, 1) do
  begin
    if prev >= 0 then yield prev * n;
    prev := n;
  end;
end;

function jacobsthalPrimes(): sequence of int64;
begin
  foreach var n in jacobsthalSequence(0, 1) do
    if isPrime(n) then yield n
end;

begin
  writeln('First 30 Jacobsthal numbers:');
  foreach var n in jacobsthalSequence(0, 1).Take(30) index i do
    write(n:11, if i mod 6 = 5 then #10 else '');

  writeln(#10, 'First 30 Jacobsthal-Lucas numbers:');
  foreach var n in jacobsthalSequence(2, 1).Take(30) index i do
    write(n:11, if i mod 6 = 5 then #10 else '');

  writeln(#10, 'First 20 Jacobsthal oblong numbers:');
  foreach var n in jacobsthalOblong().Take(20) index i do
    write(n:13, if i mod 5 = 4 then #10 else '');

  writeln(#10, 'First 10 Jacobsthal prime numbers:');
  foreach var n in jacobsthalPrimes().Take(10) index i do
    write(n:11, if i mod 5 = 4 then #10 else '');
end.
