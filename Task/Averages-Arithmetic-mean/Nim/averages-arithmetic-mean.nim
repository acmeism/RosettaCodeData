import strutils

proc mean(xs: openArray[float]): float =
  for x in xs:
    result += x
  result = result / float(xs.len)

var v = @[1.0, 2.0, 2.718, 3.0, 3.142]
for i in 0..5:
  echo "mean of first ", v.len, " = ", formatFloat(mean(v), precision = 0)
  if v.len > 0: v.setLen(v.high)
