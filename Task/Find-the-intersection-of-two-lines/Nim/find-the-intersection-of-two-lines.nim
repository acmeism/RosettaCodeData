type
  Line = tuple
    slope: float
    yInt: float
  Point = tuple
    x: float
    y: float

func createLine(a, b: Point): Line =
  result.slope = (b.y - a.y) / (b.x - a.x)
  result.yInt = a.y - result.slope * a.x

func evalX(line: Line, x: float): float =
  line.slope * x + line.yInt

func intersection(line1, line2: Line): Point =
  let x = (line2.yInt - line1.yInt) / (line1.slope - line2.slope)
  let y = evalX(line1, x)
  (x, y)

var line1 = createLine((4.0, 0.0), (6.0, 10.0))
var line2 = createLine((0.0, 3.0), (10.0, 7.0))
echo intersection(line1, line2)
line1 = createLine((0.0, 0.0), (1.0, 1.0))
line2 = createLine((1.0, 2.0), (4.0, 5.0))
echo intersection(line1, line2)
