begin

comment - return n mod m;
integer procedure mod(n, m);
  value n, m; integer n, m;
begin
  mod := n - m * entier(n / m);
end;

comment - return count of divisors of n;
integer procedure divcount(n);
  value n; integer n;
begin
  integer count, f1, f2;
  comment - every integer has at least 2 divisors (1 and n);
  count := 2;
  f1 := 2;
  for f1 := f1 while (f1 * f1) <= n do
    begin
      if mod(n, f1) = 0 then
        begin
           f2 := n / f1;
           if f2 > f1 then
              count := count + 2
           else
              count := count + 1;
        end;
      f1 := f1 + 1;
    end;
  divcount := count;
end;

comment - return true if n is prime;
boolean procedure isprime(n);
value n; integer n;
begin
    if n < 2 then
        isprime := false
    else if mod(n, 2) = 0 then
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
                 if mod(n, i) = 0 then
                     divisible := true;
                 i := i + 2
              end;
           isprime := not divisible;
        end;
end;

integer i, sq, limit, found;
limit := 100000;
outstring(1,"Integers up to");
outinteger(1, limit);
outstring(1, "with a count of divisors that is prime:\n");
found := 0;
comment - we only need to check perfect squares;
i := 2;
for sq := i * i while sq < limit do
  begin
    if isprime(divcount(sq)) then
       begin
         outinteger(1, sq);
         found := found + 1;
         if mod(found, 10) = 0 then outstring(1,"\n");
       end;
    i := i + 1;
  end;
outstring(1,"\n");
outinteger(1,found);
outstring(1,"were found\n");

end
