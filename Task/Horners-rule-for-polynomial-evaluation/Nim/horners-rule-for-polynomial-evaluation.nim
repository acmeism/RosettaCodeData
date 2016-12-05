iterator reversed(x) =
  for i in countdown(x.high, x.low):
    yield x[i]

proc horner(coeffs, x): int =
  for c in reversed(coeffs):
    result = result * x + c

echo horner([-19, 7, -4, 6], 3)
