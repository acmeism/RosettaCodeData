begin

comment - return n mod m;
integer procedure mod(n, m);
  value n, m; integer n, m;
begin
  mod := n - m * entier(n / m);
end;

comment - return sum of the proper divisors of n;
integer procedure sumf(n);
  value n; integer n;
begin
  integer sum, f1, f2;
  sum := 1;
  f1 := 2;
  for f1 := f1 while (f1 * f1) <= n do
    begin
      if mod(n, f1) = 0 then
        begin
           sum := sum + f1;
           f2 := n / f1;
           if f2 > f1 then sum := sum + f2;
        end;
      f1 := f1 + 1;
  end;
  sumf := sum;
end;

comment - main program begins here;
integer a, b, found;
outstring(1,"Searching up to 20000 for amicable pairs\n");
found := 0;
for a := 2 step 1 until 20000 do
  begin
    b := sumf(a);
    if b > a then
       begin
         if a = sumf(b) then
            begin
              found := found + 1;
              outinteger(1,a);
              outinteger(1,b);
              outstring(1,"\n");
            end;
       end;
  end;
outinteger(1,found);
outstring(1,"pairs were found");

end
