begin

boolean procedure isascending(n);
  value n; integer n;
begin
  integer i, j, q;
  boolean increasing;
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
  comment - single digit number is by definition ascending;
  if j = 1 then
    increasing := true
  else
    begin
      comment
        digits are stored in reverse order, so we
        have to work backward;
      increasing := true;
      for j := j while j > 1 and increasing do
        begin
          if d[j-1] <= d[j] then increasing := false;
          j := j - 1;
        end;
    end;
  isascending := increasing;
end;

boolean procedure isprime(n);
value n; integer n;
begin
    integer procedure mod(n, m);
    value n, m; integer n, m;
    mod := n - entier(n / m) * m;

    if n < 2 then
        isprime := false
    else if mod(n,2) = 0 then
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
                 if mod(n,i) = 0 then divisible := true;
                 i := i + 2
              end;
           isprime := not divisible;
        end;
end;

comment - main code begins here;

integer i, found;
outstring(1,"Primes with distinct ascending digits:\n");
comment - 2 (as the only even prime) is a special case;
outinteger(1,2);
found := 1;
comment
  There is only one 9 digit ascending number, so we will
  treat it as a special case and otherwise search only
  up to the largest 8-digit ascending number;
for i := 3 step 2 until 23456789 do
  begin
    if isascending(i) then
      begin
        if isprime(i) then
          begin
            outinteger(1,i);
            found := found + 1;
          end;
      end;
  end;
comment - check the only possible 9-digit candidate;
i := 123456789;
if isprime(i) then
  begin
    found := found + 1;
    outinteger(1,i);
  end;
outstring(1,"\n");
outinteger(1,found);
outstring(1,"were found");

end
