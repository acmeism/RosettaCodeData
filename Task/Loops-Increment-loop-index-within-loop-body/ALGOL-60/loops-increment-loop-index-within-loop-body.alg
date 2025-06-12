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

integer i, count;

count := 0;
for i := 42, i + 1 while count < 26 do
  begin
    if isprime(i) then
      begin
         count := count + 1;
         outinteger(1,count);
         outinteger(1,i);
         i := i + (i - 1);
         outstring(1,"\n");
      end;
  end;

end
