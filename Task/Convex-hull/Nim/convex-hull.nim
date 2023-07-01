type
  Point = object
    x: float
    y: float

# Calculate orientation for 3 points
# 0 -> Straight line
# 1 -> Clockwise
# 2 -> Counterclockwise
proc orientation(p, q, r: Point): int =
  let val = (q.y - p.y) * (r.x - q.x) -
    (q.x - p.x) * (r.y - q.y)

  if val == 0: 0
  elif val > 0: 1
  else: 2

proc calculateConvexHull(points: openArray[Point]): seq[Point] =
  result = newSeq[Point]()

  # There must be at least 3 points
  if len(points) < 3:
    for i in points: result.add(i)

  # Find the leftmost point
  var indexMinX = 0
  for i, _ in points:
    if points[i].x < points[indexMinX].x:
      indexMinX = i

  var p = indexMinX
  var q = 0

  while true:
    # The leftmost point must be part of the hull.
    result.add(points[p])

    q = (p + 1) mod len(points)

    for i in 0..<len(points):
      if orientation(points[p], points[i], points[q]) == 2:
        q = i

    p = q

    # Break from loop once we reach the first point again
    if p == indexMinX:
      break

var points = @[Point(x: 16, y: 3),
               Point(x: 12, y: 17),
               Point(x: 0, y: 6),
               Point(x: -4, y: -6),
               Point(x: 16, y: 6),
               Point(x: 16, y: -7),
               Point(x: 17, y: -4),
               Point(x: 5, y: 19),
               Point(x: 19, y: -8),
               Point(x: 3, y: 16),
               Point(x: 12, y: 13),
               Point(x: 3, y: -4),
               Point(x: 17, y: 5),
               Point(x: -3, y: 15),
               Point(x: -3, y: -9),
               Point(x: 0, y: 11),
               Point(x: -9, y: -3),
               Point(x: -4, y: -2),
               Point(x: 12, y: 10)]

let hull = calculateConvexHull(points)
for i in hull:
  echo i
