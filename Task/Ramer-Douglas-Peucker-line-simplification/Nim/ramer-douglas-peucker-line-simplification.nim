import math

type
  Point = tuple[x, y: float64]

proc pointLineDistance(pt, lineStart, lineEnd: Point): float64 =
  var n, d, dx, dy: float64
  dx = lineEnd.x - lineStart.x
  dy = lineEnd.y - lineStart.y
  n = abs(dx * (lineStart.y - pt.y) - (lineStart.x - pt.x) * dy)
  d = sqrt(dx * dx + dy * dy)
  n / d

proc rdp(points: seq[Point], startIndex, lastIndex: int, ε: float64 = 1.0): seq[Point] =
  var dmax = 0.0
  var index = startIndex

  for i in index+1..<lastIndex:
    var d = pointLineDistance(points[i], points[startIndex], points[lastIndex])
    if d > dmax:
      index = i
      dmax = d

  if dmax > ε:
    var res1 = rdp(points, startIndex, index, ε)
    var res2 = rdp(points, index, lastIndex, ε)

    var finalRes: seq[Point] = @[]
    finalRes.add(res1[0..^2])
    finalRes.add(res2[0..^1])

    result = finalRes
  else:
    result = @[points[startIndex], points[lastIndex]]

var line: seq[Point] = @[(0.0, 0.0), (1.0, 0.1), (2.0, -0.1), (3.0, 5.0), (4.0, 6.0),
                         (5.0, 7.0), (6.0, 8.1), (7.0,  9.0), (8.0, 9.0), (9.0, 9.0)]
echo rdp(line, line.low, line.high)
