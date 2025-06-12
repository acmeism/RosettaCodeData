begin

comment - return n mod m;
integer procedure mod(n, m);
  value n, m; integer n, m;
begin
  mod := n - entier(n / m) * m;
end;

integer i, k, m, n, sq, nprimes;
boolean divisible;

nprimes := 20;
outstring(1,"Showing first");
outinteger(1, nprimes);
outstring(1,"prime numbers\n");
begin
  integer array p[1:nprimes];
  comment - initialize p with first (and only even) prime;
  p[1] := 2;
  outinteger(1, p[1]);
  i := 1; comment - count of primes found so far;
  k := 1; comment - index of largest prime <= sqrt of n;
  n := 3; comment - current number being checked;
  for i := i while i < nprimes do
    begin
      sq := p[k] * p[k];
      if sq <= n then k := k + 1;
      divisible := false;
      m := 2; comment - index of possible divisors;
      for m := m while m <= k and not divisible do
        begin
          if mod(n, p[m]) = 0 then divisible := true;
          m :=  m + 1;
        end;
      if not divisible then
        begin
          i := i + 1;
          p[i] := n;
          outinteger(1, n);
        end;
      n := n + 2;
    end;
  end;

end
