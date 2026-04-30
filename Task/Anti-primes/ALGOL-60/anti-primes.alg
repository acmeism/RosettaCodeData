begin

comment
  An ALGOL 60 program to generate the first 20 anti-primes, i.e.,
  composite numbers whose number of divisors is greater than that
  of any lesser number;

integer procedure mod(a, b);
  value a, b; integer a, b;
begin
  mod := a - entier(a/b) * b;
end;

integer procedure divcount(n);
  value n; integer n;
begin
  integer i, count;
  if n = 1 then count := 1 else count := 2;
  for i := 2 step 1 until entier(n/2) do
    begin
      if mod(n,i) = 0 then count := count + 1;
    end;
  divcount := count;
end;

integer i, ndiv, maxsofar, nfound;
maxsofar := 0;
nfound := 0;
for i := 1, i+1 while nfound < 20 do
  begin
    ndiv := divcount(i);
    if ndiv > maxsofar then
      begin
	    maxsofar := ndiv;
        nfound := nfound+1;
        outinteger(1,i);
      end;
  end;

end
