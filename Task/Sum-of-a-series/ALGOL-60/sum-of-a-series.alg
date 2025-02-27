begin

comment - return sum from a to b of the series 1 / k^2;

real procedure suminvsq(a, b);
  value a, b; real a, b;
begin
  real k, sum;
  sum := 0;
  for k := a step 1 until b do
    sum := sum + 1 / (k * k);
  suminvsq := sum;
end;

comment - show result for 1..1000
outreal(1,suminvsq(1,1000));

end
