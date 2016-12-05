import math

proc nosqr(n): seq[int] =
  result = @[]
  for i in 1..n:
    result.add(i + round(sqrt(float(i))))

proc issqr(n): bool =
  let sqr = sqrt(float(n))
  let err = abs(sqr - float(round(sqr)))
  err < 1e-7

echo nosqr(22)
for i in nosqr(1_000_000):
  assert(not issqr(i))
