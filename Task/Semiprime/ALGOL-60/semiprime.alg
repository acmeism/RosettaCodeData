begin

comment - return a mod b;
integer procedure mod(a, b);
  value a, b; integer a, b;
begin
  mod := a - entier(a/b) * b;
end;

comment - return true if n is a semi-prime number;
boolean procedure semiprime(n);
  value n; integer n;
begin
  integer i, count;
  count := 1;
  i := 2;
  for i := i while (i * i) <= n do
    begin
      if mod(n, i) = 0 then
        begin
          count := count + 1;
          n := n / i;
        end
      else
        i := i + 1;
    end;
  semiprime := (count = 2);
end;

integer i, limit, found;
limit := 100;
outstring(1,"Searching up to");
outinteger(1,limit);
outstring(1,"for semi-primes:\n");
found := 0;
for i := 3 step 1 until limit do
  begin
    if semiprime(i) then
      begin
         outinteger(1,i);
         found := found + 1;
         if mod(found, 10) = 0 then outstring(1,"\n");
      end;
  end;
outstring(1,"\n");
outinteger(1,found);
outstring(1,"were found");
end
