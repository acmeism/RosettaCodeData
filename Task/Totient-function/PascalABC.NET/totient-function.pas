uses school;

function totient(n: int64) := (1..n).Select(k -> (if gcd(n, k) = 1 then 1 else 0)).Sum;

function is_prime(n: int64) := totient(n) = n - 1;

begin
  foreach var n in 1..25 do
    writeln('φ(', n, ') = ', totient(n), if is_prime(n) then ', is prime' else '');
  var count := 0;
  foreach var n in 1..100_000 do
  begin
    count += if is_prime(n) then 1 else 0;
    if n in |100, 1000, 10_000, 100_000| then
      writeln('Primes up to ', n, ': ', count);
  end;
end.
