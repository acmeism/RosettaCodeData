import math

type
  Point = tuple[x, y: float]
  Circle = tuple[x, y, r: float]

proc circles(p1, p2: Point, r: float): tuple[c1, c2: Circle] =
  if r == 0: raise newException(ValueError,
    "radius of zero")
  if p1 == p2: raise newException(ValueError,
    "coincident points gives infinite number of Circles")

  # delta x, delta y between points
  let (dx, dy) = (p2.x - p1.x, p2.y - p1.y)
  # dist between points
  let q = sqrt(dx*dx + dy*dy)
  if q > 2.0*r: raise newException(ValueError,
    "separation of points > diameter")

  # halfway point
  let p3: Point = ((p1.x+p2.x)/2, (p1.y+p2.y)/2)
  # distance along the mirror line
  let d = sqrt(r*r - (q/2)*(q/2))
  # One answer
  result.c1 = (p3.x - d*dy/q, p3.y + d*dx/q, abs(r))
  # The other answer
  result.c2 = (p3.x + d*dy/q, p3.y - d*dx/q, abs(r))

const tries: seq[tuple[p1, p2: Point, r: float]] =
  @[((0.1234, 0.9876), (0.8765, 0.2345), 2.0),
    ((0.0000, 2.0000), (0.0000, 0.0000), 1.0),
    ((0.1234, 0.9876), (0.1234, 0.9876), 2.0),
    ((0.1234, 0.9876), (0.8765, 0.2345), 0.5),
    ((0.1234, 0.9876), (0.1234, 0.9876), 0.0)]

for p1, p2, r in tries.items:
  echo "Through points:"
  echo "  ", p1
  echo "  ", p2
  echo "  and radius ", r
  echo "You can construct the following circles:"
  try:
    let (c1, c2) = circles(p1, p2, r)
    echo "  ", c1
    echo "  ", c2
  except ValueError:
    echo "  ERROR: ", getCurrentExceptionMsg()
  echo ""
