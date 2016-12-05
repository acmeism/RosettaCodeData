import math
randomize()

proc pi(nthrows): float =
  var inside = 0
  for i in 1..int64(nthrows):
    if hypot(random(1.0), random(1.0)) < 1:
      inc inside
  return float(4 * inside) / nthrows

for n in [10e4, 10e6, 10e7, 10e8]:
  echo pi(n)
