begin

comment - return n mod m;
integer procedure mod(n,m);
  value n, m; integer n, m;
begin
  mod := n - m * entier(n / m);
end;

integer i, limit;
real sum;

limit := 1000;
sum := 0;
for i := 1 step 1 until (limit - 1) do
  if mod(i, 3) = 0 or mod(i, 5) = 0 then
     sum := sum + i;
outreal(1,sum);

end
