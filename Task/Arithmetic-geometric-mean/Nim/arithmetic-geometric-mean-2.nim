from math import sqrt
from strutils import parseFloat, formatFloat, ffDecimal

proc agm(x,y: float): tuple[resA,resG: float] =
  var
    a,g: array[0 .. 23,float]

  a[0] = x
  g[0] = y

  for n in 1 .. 23:
    a[n] = 0.5 * (a[n - 1] + g[n - 1])
    g[n] = sqrt(a[n - 1] * g[n - 1])

  (a[23], g[23])

var t = agm(1, 1/sqrt(2))

echo("Result A: " & formatFloat(t.resA, ffDecimal, 24))
echo("Result G: " & formatFloat(t.resG, ffDecimal, 24))
