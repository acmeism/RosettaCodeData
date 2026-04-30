begin

comment - return n mod m;
integer procedure mod(n, m);
  value n, m; integer n, m;
begin
  mod := n - entier(n/m) * m;
end;

comment - return number of divisors of n;
integer procedure tau(n);
  value n; integer n;
begin
  integer i, t, limit;
  if n < 3 then
     t := n
  else
     begin
       t := 2;
       limit := (n + 1) / 2;
       for i := 2 step 1 until limit do
          begin
             if mod(n, i) = 0 then t := t + 1;
          end;
     end;
  tau := t;
end;

integer i;
outstring(1,"Number of divisors of first 100 numbers\n");
for i := 1 step 1 until 100 do
  begin
    outinteger(1,tau(i));
    if mod(i,10) = 0 then outstring(1,"\n");
  end;

end
