begin

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

comment - exercise the procedure;
integer i;
outstring(1,"Testing first 50 numbers for primality:\n");
for i := 1 step 1 until 50 do
  if isprime(i) then
      outinteger(1,i);

end
