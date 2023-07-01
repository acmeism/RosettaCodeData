type
  Point = tuple
    x: float
    y: float

func shoelace(points: openArray[Point]): float =
  var leftSum, rightSum = 0.0
  for i in 0..<len(points):
    var j = (i + 1) mod len(points)
    leftSum  += points[i].x * points[j].y
    rightSum += points[j].x * points[i].y
  0.5 * abs(leftSum - rightSum)

var points = [(3.0, 4.0), (5.0, 11.0), (12.0, 8.0), (9.0, 5.0), (5.0, 6.0)]

echo shoelace(points)
