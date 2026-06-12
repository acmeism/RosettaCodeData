BEGIN {
  printf ("estimate of ∫ sin x dx from 0 to 1: %f\n",
          quad_asr(0.0, 1.0, 1.0e-9, 100))
}

function f(x)
{
  return sin(x)
}

function midpoint(a, b)
{
  return 0.5 * (a + b)
}

function simpson_rule(a, fa, b, fb, fm)
{
  return ((b - a) / 6.0) * (fa + (4.0 * fm) + fb)
}

function recursive_simpson(a, fa, b, fb, tol, whole, m, fm, depth,
                           # Local variables:
                           lm, flm, left,
                           rm, frm, right,
                           delta, tol_,
                           leftval, rightval, quadval)
{
  lm = midpoint(a, m)
  flm = f(lm)
  left = simpson_rule(a, fa, m, fm, flm)

  rm = midpoint(m, b)
  frm = f(rm)
  right = simpson_rule(m, fm, b, fb, frm)

  delta = left + right - whole
  tol_ = 0.5 * tol

  if (depth <= 0 || tol_ == tol || abs(delta) <= 15.0 * tol)
    quadval = left + right + (delta / 15.0)
  else
    {
      leftval = recursive_simpson(a, fa, m, fm, tol_,
                                  left, lm, flm, depth - 1)
      rightval = recursive_simpson(m, fm, b, fb, tol_,
                                   right, rm, frm, depth - 1)
      quadval = leftval + rightval
    }
  return quadval
}

function quad_asr(a, b, tol, depth,
                  # Local variables:
                  fa, fb, whole, m, fm)
{
  fa = f(a)
  fb = f(b)

  m = midpoint(a, b)
  fm = f(m)
  whole = simpson_rule(a, fa, b, fb, fm)

  return recursive_simpson(a, fa, b, fb, tol,
                           whole, m, fm, depth)
}

function abs(x)
{
  return (x < 0 ? -x : x)
}
