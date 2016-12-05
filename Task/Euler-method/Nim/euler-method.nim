import strutils

proc euler(f: proc (x,y: float): float; y0, a, b, h: float) =
  var (t,y) = (a,y0)
  while t < b:
    echo formatFloat(t, ffDecimal, 3), " ", formatFloat(y, ffDecimal, 3)
    t += h
    y += h * f(t,y)

proc newtoncooling(time, temp): float =
  -0.07 * (temp - 20)

euler(newtoncooling, 100.0, 0.0, 100.0, 10.0)
