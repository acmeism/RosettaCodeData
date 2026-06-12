begin

boolean procedure ispalindrome(n);
  value n; integer n;
begin
  integer i, j, q;
  integer array d[1:10];
  comment - decompose n into its digits;
  j := 0;
  for j := j while n > 0 do
    begin
      j := j + 1;
      q := entier(n / 10);
      d[j] := n - q * 10;
      n := q;
    end;
  comment - move from outside in checking for equality;
  i := 1;
  for i := i while (i < j) and (d[i] = d[j]) do
    begin
      i := i + 1;
      j := j - 1;
    end;
  ispalindrome := d[i] = d[j];
end;

boolean procedure isprime(n);
value n; integer n;
begin
    comment - local procedure tests whether n is even;
    boolean procedure even(n);
    value n; integer n;
    even := entier(n / 2) * 2 = n;

    if n < 2 then
        isprime := false
    else if even(n) then
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

comment - main code begins here;

integer i, count;
count := 0;
for i := 2 step 1 until 999 do
  if isprime(i) then
     begin
        if ispalindrome(i) then
           begin
              outinteger(1,i);
              count := count + 1;
           end;
     end;
outstring(1,"\n");
outinteger(1,count);
outstring(1,"palindromic primes were found below 1000");

end
