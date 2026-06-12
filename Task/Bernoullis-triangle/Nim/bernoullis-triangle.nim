from math import binom

proc bern_tri(n: int): seq[int] =
  result.add(1)
  for k in 1..n:
    result.add(result[^1] + binom(n, k))

for n in 0..<15:
  echo bern_tri(n)
