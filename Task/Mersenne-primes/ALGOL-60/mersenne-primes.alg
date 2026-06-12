begin

integer procedure mersenne(n);
value n; integer n;
begin
    integer i, m;
    m := 1;
    for i := 1 step 1 until n do
        m := m * 2;
    mersenne := m - 1;
end;

boolean procedure isprime(n);
value n; integer n;
begin
    if n < 2 then
        isprime := false
    else if entier(n / 2) * 2 = n then
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
           isprime := if divisible then false else true;
        end;
end;

comment - main code begins here;

integer i, m;

outstring(1,"Searching to M(31) for Mersenne primes\n");
for i := 1 step 1 until 31 do
    begin
        m := mersenne(i);
        if isprime(m) then
            begin
                outstring(1,"M(");
                outinteger(1,i);
                outstring(1,") : ");
                outinteger(1,m);
                outstring(1,"\n");
            end;
    end;

end
