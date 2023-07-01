import math

proc isPerfect(n: int): bool =
  var sum: int = 1
  for d in 2 .. int(n.toFloat.sqrt):
    if n mod d == 0:
      inc sum, d
      let q = n div d
      if q != d: inc sum, q
  result = n == sum

for n in 2..10_000:
  if n.isPerfect:
    echo n
