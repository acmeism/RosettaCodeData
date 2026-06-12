import math, sugar

type Func = float -> float

proc quadSimpsonsMem(f: Func; a, fa, b, fb: float): tuple[m, fm, val: float] =
  ## Evaluates the Simpson's Rule, also returning m and f(m) to reuse
  result.m = (a + b) / 2
  result.fm = f(result.m)
  result.val = abs(b - a) * (fa + 4 * result.fm + fb) / 6

proc quadAsr(f: Func; a, fa, b, fb, eps, whole, m, fm: float): float =
  ## Efficient recursive implementation of adaptive Simpson's rule.
  ## Function values at the start, middle, end of the intervals are retained.
  let (lm, flm, left) = f.quadSimpsonsMem(a, fa, m, fm)
  let (rm, frm, right) = f.quadSimpsonsMem(m, fm, b, fb)
  let delta = left + right - whole
  result = if abs(delta) <= 15 * eps:
             left + right + delta / 15
           else:
             f.quadAsr(a, fa, m, fm, eps / 2, left, lm, flm) +
             f.quadAsr(m, fm, b, fb, eps / 2, right, rm, frm)

proc quadAsr(f: Func; a, b, eps: float): float =
  ## Integrate f from a to b using Adaptive Simpson's Rule with max error of eps.
  let fa = f(a)
  let fb = f(b)
  let (m, fm, whole) = f.quadSimpsonsMem(a, fa, b, fb)
  result = f.quadAsr(a, fa, b, fb, eps, whole, m, fm)

echo "Simpson's integration of sine from 0 to 1 = ", sin.quadAsr(0, 1, 1e-9)
