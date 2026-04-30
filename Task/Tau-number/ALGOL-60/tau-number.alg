begin

comment - return n mod m;
integer procedure mod(n, m);
  value n, m; integer n, m;
begin
  mod := n - entier(n / m) * m;
end;

comment - return the Tau (number of divisors) of n;
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

comment - output n to screen in field of width w;
procedure outdec(n, w);
  value n, w; integer n, w;
begin
  integer m;
  m := 10 ** (w-1);
  for m := m, m/10 while n < m do
    begin
      outstring(1," ");
    end;
  outinteger(1,n);
end;

integer i, found;
outstring(1,"First 100 Tau numbers:\n");
found := 0;
for i := 1, i+1 while found < 100 do
  begin
    if mod(i,tau(i)) = 0 then
      begin
        outdec(i,5);
        found := found + 1;
        if mod(found,10) = 0 then outstring(1,"\n");
      end;
  end;

end
