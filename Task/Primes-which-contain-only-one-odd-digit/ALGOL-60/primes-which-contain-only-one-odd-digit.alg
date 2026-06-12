begin

integer procedure mod(a, b);
  value a, b; integer a, b;
begin
  mod := a - entier(a / b) * b;
end;

comment
  return the number of odd digits in the decimal
  representation of n;

integer procedure oddigits(n);
  value n; integer n;
begin
  integer q, d, count;
  count := 0;
  for n := n while n > 0 do
    begin
      q := entier(n / 10);
      d := n - q * 10;
      if mod(d, 2) = 1 then count := count + 1;
      n := q;
    end;
  oddigits := count;
end;


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
                 if mod(n, i) = 0 then divisible := true;
                 i := i + 2
              end;
           isprime := not divisible;
        end;
end;

comment - main code begins here;

integer i, count;
outstring(1,"Prime numbers up to 1000 with only one odd digit:\n");
count := 0;
for i := 3 step 2 until 1000 do
  if isprime(i) then
     begin
        if oddigits(i) = 1 then
           begin
              outinteger(1,i);
              count := count + 1;
              if mod(count, 8) = 0 then outstring(1, "\n");
           end;
     end;
outstring(1,"\n");
outinteger(1,count);
outstring(1,"were found");

end
