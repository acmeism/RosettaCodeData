type
  Point = object
    x, y: float

  Circle = object
    center: Point
    radius: float

# Constructors
proc createPoint(x, y = 0.0): Point =
  result.x = x
  result.y = y

proc createCircle(x, y = 0.0, radius = 1.0): Circle =
  result.center.x = x
  result.center.y = y
  result.radius = radius

var p1 = createPoint()
echo "p1: ", p1 # We use the default $ operator for printing
var p2 = createPoint(3, 4.2)
var p3 = createPoint(x = 2)
var p4 = createPoint(y = 2.5)

p2 = p4
p3 = createPoint()

var c1 = createCircle()
echo "c1: ", c1
var c2 = createCircle(2, 0.5, 4.2)
var c3 = createCircle(x = 2.1, y = 2)
var c4 = createCircle(radius = 10)

c1.center.x = 12
c1.radius = 5.2
