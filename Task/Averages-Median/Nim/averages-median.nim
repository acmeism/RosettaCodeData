import algorithm, strutils

proc median(xs: seq[float]): float =
  var ys = xs
  sort(ys, system.cmp[float])
  0.5 * (ys[ys.high div 2] + ys[ys.len div 2])

var a = @[4.1, 5.6, 7.2, 1.7, 9.3, 4.4, 3.2]
echo formatFloat(median(a), precision = 0)
a = @[4.1, 7.2, 1.7, 9.3, 4.4, 3.2]
echo formatFloat(median(a), precision = 0)
