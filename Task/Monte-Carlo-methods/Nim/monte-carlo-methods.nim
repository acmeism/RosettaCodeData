import math, random

randomize()

proc pi(nthrows: float): float =
  var inside = 0.0
  for i in 1..int64(nthrows):
    if hypot(rand(1.0), rand(1.0)) < 1:
      inside += 1
  result = 4 * inside / nthrows

for n in [10e4, 10e6, 10e7, 10e8]:
  echo pi(n)
