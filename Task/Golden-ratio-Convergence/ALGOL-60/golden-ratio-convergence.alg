procedure iterate (phi0, n0, phi, n);
  value phi0, n0;
  real phi0, phi;
  integer n0, n;
begin
  phi := 1.0 + (1.0 / phi0);
  n := n0 + 1;
  if 100000.0 * abs (phi - phi0) > 1.0 then
    iterate (phi, n, phi, n)
end iterate;

begin
  real phi;
  integer n;

  iterate (1.0, 0, phi, n);
  outstring (1, "Result: ");
  outreal (1, phi);
  outstring (1, "after ");
  outinteger (1, n);
  outstring (1, "iterations\n");
  outstring (1, "The error is approximately ");
  outreal (1, phi - (0.5 * (1.0 + sqrt (5.0))));
  outstring (1, "\n")
end
