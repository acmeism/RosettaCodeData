import math, sequtils, strutils

proc rn(n, k: Positive): seq[int] =
  assert k >= 2
  result = if n == 2: @[1, 1, 1] else: rn(n - 1, n + 1)
  while result.len != k:
    result.add sum(result[^(n + 1)..^2])

for n in 2..8:
  echo n, ": ", rn(n, 15).mapIt(($it).align(3)).join(" ")
