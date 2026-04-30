begin

real procedure poly(c, n, x);
  value n, x; real array c; integer n; real x;
begin
  integer i, h;
  h := 0;
  for i := n step -1 until 1 do
    h := (h * x) + c[i];
  poly := h;
end;

real array coeffs[1:4];
outstring(1,"Value of 6x^3 - 4x^2 + 7x - 19 at x=3:");
coeffs[1] := -19; coeffs[2] := 7; coeffs[3] := -4; coeffs[4] := 6;
outreal(1, poly(coeffs, 4, 3.0));

end
