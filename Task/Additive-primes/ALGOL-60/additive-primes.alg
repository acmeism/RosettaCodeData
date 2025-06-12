begin

integer procedure sumdigits(n);
  value n; integer n;
begin
  integer q, sum;
  sum := 0;
  for sum := sum while n > 0 do
    begin
      q := entier(n / 10);
      sum := sum + (n - q * 10);
      n := q;
    end;
  sumdigits := sum;
end;

boolean procedure isprime(n);
value n; integer n;
begin
    if n < 2 then
        isprime := false
    else if n = entier(n / 2) * 2 then
        isprime := (n = 2)
    else
        begin
           comment - check odd divisors up to sqrt(n);
           integer i, limit;
           boolean divisible;
           i := 3;
           limit := entier(sqrt(n));
           divisible := false;
           for i := i while i <= limit and not divisible do
              begin
                 if entier(n / i) * i = n then
                     divisible := true;
                 i := i + 2
              end;
           isprime := not divisible;
        end;
end;

integer i, count;
outstring(1,"Looking up to 500 for additive primes\n");
count := 0;
for i := 2 step 1 until 500 do
  if isprime(i) then
     begin
       if isprime(sumdigits(i)) then
         begin
          outinteger(1,i);
          count := count + 1;
          if count = entier(count / 10) * 10 then
            outstring(1,"\n");
         end;
     end;
outstring(1,"\n");
outinteger(1,count);
outstring(1,"were found\n");

end
