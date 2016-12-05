var i: int

proc harmonicSum(i: var int, lo, hi, term): float =
  i = lo
  while i <= hi:
    result += term()
    inc i

echo harmonicSum(i, 1, 100, proc: float = 1.0 / float(i))
