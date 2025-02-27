begin

comment - return the nth root of x to stated precision;
real procedure nthroot(x, n, precision);
  value x, n, precision; real x, n, precision;
begin
  real x0, x1;
  x0 := x;
  x1 := x / n;
  for x0 := x0 while abs(x1 - x0) > precision do
    begin
      x0 := x1;
      x1 := ((n-1)*x1 + x / x1 ** (n-1)) / n;
    end;
  nthroot := x1;
end;

outstring(1,"Cube root of 81 =");
outreal(1,nthroot(81, 3, 0.0000001));

end
