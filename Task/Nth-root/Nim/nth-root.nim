import math

proc nthRoot(a: float; n: int): float =
  var n = float(n)
  result = a
  var x = a / n
  while abs(result-x) > 1e-15:
    x = result
    result = (1/n) * (((n-1)*x) + (a / pow(x, n-1)))

echo nthRoot(34.0, 5)
echo nthRoot(42.0, 10)
echo nthRoot(5.0, 2)
