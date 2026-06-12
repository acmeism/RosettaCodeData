procedure simpsonrule (f, a, fa, b, fb, m, fm, quadval);
  value a, fa, b, fb;
  real procedure f;
  real a, fa, b, fb, m, fm, quadval;
begin
  m := (a + b) / 2;
  fm := f(m);
  quadval := ((b - a) / 6) * (fa + (4 * fm) + fb)
end simpsonrule;

real procedure recursion (f, a, fa, b, fb, tol, whole, m, fm, depth);
  value a, fa, b, fb, tol, whole, m, fm, depth;
  real procedure f;
  real a, fa, b, fb, tol, whole, m, fm;
  integer depth;
begin
  real lm, flm, left;
  real rm, frm, right;
  real delta, tol2;
  simpsonrule (f, a, fa, m, fm, lm, flm, left);
  simpsonrule (f, m, fm, b, fb, rm, frm, right);
  delta := left + right - whole;
  tol2 := tol / 2;
  if depth <= 0 | tol2 = tol | abs (delta) <= 15 * tol then
    recursion := left + right + (delta / 15)
  else
    recursion :=
      recursion (f, a, fa, m, fm, tol2, left , lm, flm, depth - 1)
        + recursion (f, m, fm, b, fb, tol2, right, rm, frm, depth - 1)
end recursion;

real procedure quadASR (f, a, b, tol, depth);
  value a, b, tol, depth;
  real procedure f;
  real a, b, tol;
  integer depth;
begin
  real fa, fb, m, fm, whole;
  fa := f(a);
  fb := f(b);
  simpsonrule (f, a, fa, b, fb, m, fm, whole);
  quadASR := recursion (f, a, fa, b, fb, tol, whole, m, fm, depth)
end quadASR;

begin
  real q;
  q := quadASR (sin, 0, 1, 0.000000001, 1000);
  outstring (1, "estimated definite integral of sin(x) ");
  outstring (1, "for x from 0 to 1: ");
  outreal (1, q);
  outstring (1, "\n")
end
