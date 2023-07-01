import math
import strformat

proc catalan1(n: int): int =
  binom(2 * n, n) div (n + 1)

proc catalan2(n: int): int =
  if n == 0:
    return 1
  for i in 0..<n:
    result += catalan2(i) * catalan2(n - 1 - i)

proc catalan3(n: int): int =
  if n > 0: 2 * (2 * n - 1) * catalan3(n - 1) div (1 + n)
  else: 1

for i in 0..15:
  echo &"{i:7} {catalan1(i):7} {catalan2(i):7} {catalan3(i):7}"
