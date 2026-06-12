program chebycoefs(output);
(* Chebyshev coefficients *)

const
  maxn = 10;
  lastindx = 9; (* maxn - 1 *)
  pi = 3.1415926535897932384626433832795;
var
  cheby, coef: array [0 .. lastindx] of real;
  a, b, w: real;
  pidivn, bpladiv2, bmiadiv2: real;
  n, i, j: 1 .. maxn;
begin
  a := 0; b := 1; n := 10;
  pidivn := pi / n;
  bpladiv2 := (b + a) * 0.5;
  bmiadiv2 := (b - a) * 0.5;
  for i := 0 to n - 1 do
    coef[i] := cos(cos(pidivn * (i + 0.5)) * bmiadiv2 + bpladiv2);
  for i := 0 to n - 1 do
  begin
    w := 0;
    for j := 0 to n - 1 do
      w := w + coef[j] * cos(pidivn * i * (j + 0.5));
    cheby[i] := w * 2 / n;
    writeln(i, ': ', cheby[i]);
  end
end.
