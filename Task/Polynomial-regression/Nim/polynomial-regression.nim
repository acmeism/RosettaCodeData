import lenientops, sequtils, stats, strformat

proc polyRegression(x, y: openArray[int]) =

  let xm = mean(x)
  let ym = mean(y)
  let x2m = mean(x.mapIt(it * it))
  let x3m = mean(x.mapIt(it * it * it))
  let x4m = mean(x.mapIt(it * it * it * it))
  let xym = mean(zip(x, y).mapIt(it[0] * it[1]))
  let x2ym = mean(zip(x, y).mapIt(it[0] * it[0] * it[1]))

  let sxx = x2m - xm * xm
  let sxy = xym - xm * ym
  let sxx2 = x3m - xm * x2m
  let sx2x2 = x4m - x2m * x2m
  let sx2y = x2ym - x2m * ym

  let b = (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
  let c = (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
  let a = ym - b * xm - c * x2m

  func abc(x: int): float = a + b * x + c * x * x

  echo &"y = {a} + {b}x + {c}x²\n"
  echo " Input  Approximation"
  echo " x   y     y1"
  for (xi, yi) in zip(x, y):
    echo &"{xi:2} {yi:3}  {abc(xi):5}"


let x = toSeq(0..10)
let y = [1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321]
polyRegression(x, y)
