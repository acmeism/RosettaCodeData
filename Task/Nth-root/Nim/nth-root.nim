import math

proc nthroot(a, n): float =
  var n = float(n)
  result = a
  var x = a / n
  while abs(result-x) > 10e-15:
    x = result
    result = (1.0/n) * (((n-1)*x) + (a / pow(x, n-1)))

echo nthroot(34.0, 5)
echo nthroot(42.0, 10)
echo nthroot(5.0, 2)
