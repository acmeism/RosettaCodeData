begin

% return the value of n mod m %
integer function mod(n, m);
integer n, m;
begin
  mod := n - m * (n / m);
end;

% return the tau value (i.e, number of divisors) of n %
integer function tau(n);
integer n;
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

% test by printing the tau value of the first 100 numbers %
integer i;
write("Count of divisors for first 100 numbers:");
write("");
for i := 1 step 1 until 100 do
   begin
      writeon(tau(i));
      if mod(i,10) = 0 then write(""); % print 10 across %
   end;

end
