import strutils

proc droot(n: int64): auto =
  var x = @[n]
  while x[x.high] > 10:
    var s = 0'i64
    for dig in $x[x.high]:
      s += parseInt("" & dig)
    x.add s
  return (x.len - 1, x[x.high])

for n in [627615'i64, 39390'i64, 588225'i64, 393900588225'i64]:
  let (a, d) = droot(n)
  echo align($n, 12)," has additive persistance ",a," and digital root of ",d
