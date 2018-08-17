import math

proc nosqr(n: int): seq[int] =
  result = newSeq[int] n
  for i in 1..n:
    result[i - 1] = i + i.float.sqrt.round.int

proc issqr(n: int): bool =
  let sqr = sqrt(float(n))
  let err = abs(sqr - float(round(sqr)))
  err < 1e-7

echo nosqr(22)
for i in nosqr(1_000_000):
  assert(not issqr(i))
