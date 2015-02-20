function rnorm (mean, sd: real): real;
 {Calculates Gaussian random numbers according to the Box-Müller approach}
var
  u1, u2: real;
begin
  u1 := random;
  u2 := random;
  rnorm := mean * abs(1 + sqrt(-2 * (ln(u1))) * cos(2 * pi * u2) * sd);
end;
