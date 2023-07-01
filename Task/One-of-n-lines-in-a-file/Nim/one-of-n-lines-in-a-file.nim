import random
randomize()

proc oneOfN(n: int): int =
  result = 0
  for x in 0 ..< n:
    if random(x) == 0:
      result = x

proc oneOfNTest(n = 10, trials = 1_000_000): seq[int] =
  result = newSeq[int](n)
  if n > 0:
    for i in 1..trials:
      inc result[oneOfN(n)]

echo oneOfNTest()
