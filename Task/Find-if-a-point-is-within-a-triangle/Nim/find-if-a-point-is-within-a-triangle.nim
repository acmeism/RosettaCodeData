import strformat

const
  Eps = 0.001
  Eps2 = Eps * Eps

type
  Point = tuple[x, y: float]
  Triangle = object
    p1, p2, p3: Point


func initTriangle(p1, p2, p3: Point): Triangle =
  Triangle(p1: p1, p2: p2, p3: p3)

func side(p1, p2, p: Point): float =
  (p2.y - p1.y) * (p.x - p1.x) + (-p2.x + p1.x) * (p.y - p1.y)


func distanceSquarePointToSegment(p1, p2, p: Point): float =
  let p1P2SquareLength = (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)
  let dotProduct = ((p.x - p1.x) * (p2.x - p1.x) + (p.y - p1.y) * (p2.y - p1.y)) / p1P2SquareLength
  if dotProduct < 0:
    return (p.x - p1.x) * (p.x - p1.x) + (p.y - p1.y) * (p.y - p1.y)
  if dotProduct <= 1:
    let pP1SquareLength = (p1.x - p.x) * (p1.x - p.x) + (p1.y - p.y) * (p1.y - p.y)
    return pP1SquareLength - dotProduct * dotProduct * p1P2SquareLength
  result = (p.x - p2.x) * (p.x - p2.x) + (p.y - p2.y) * (p.y - p2.y)


func pointInTriangleBoundingBox(t: Triangle; p: Point): bool =
  let xMin = min(t.p1.x, min(t.p2.x, t.p3.x)) - EPS
  let xMax = max(t.p1.x, max(t.p2.x, t.p3.x)) + EPS
  let yMin = min(t.p1.y, min(t.p2.y, t.p3.y)) - EPS
  let yMax = max(t.p1.y, max(t.p2.y, t.p3.y)) + EPS
  result = p.x in xMin..xMax and p.y in yMin..yMax


func nativePointInTriangle(t: Triangle; p: Point): bool =
  let checkSide1 = side(t.p1, t.p2, p) >= 0
  let checkSide2 = side(t.p2, t.p3, p) >= 0
  let checkSide3 = side(t.p3, t.p1, p) >= 0
  result = checkSide1 and checkSide2 and checkSide3


func accuratePointInTriangle(t: Triangle; p: Point): bool =
  if not t.pointInTriangleBoundingBox(p):
    return false
  if t.nativePointInTriangle(p):
    return true
  if distanceSquarePointToSegment(t.p1, t.p2, p) <= Eps2 or
     distanceSquarePointToSegment(t.p3, t.p1, p) <= Eps2:
    return true


func `$`(p: Point): string = &"({p.x}, {p.y})"

func `$`(t: Triangle): string = &"Triangle[{t.p1}, {t.p2}, {t.p3}]"

func contains(t: Triangle; p: Point): bool = t.accuratePointInTriangle(p)


when isMainModule:

  proc test(t: Triangle; p: Point) =
    echo t
    echo &"Point {p} is within triangle ? {p in t}"

  var p1: Point = (1.5, 2.4)
  var p2: Point = (5.1, -3.1)
  var p3: Point = (-3.8, 1.2)
  var tri = initTriangle(p1, p2, p3)
  test(tri, (0.0, 0.0))
  test(tri, (0.0, 1.0))
  test(tri, (3.0, 1.0))
  echo()
  p1 = (1 / 10, 1 / 9)
  p2 = (100 / 8, 100 / 3)
  p3 = (100 / 4, 100 / 9)
  tri = initTriangle(p1, p2, p3)
  let pt = (p1.x + 3.0 / 7 * (p2.x - p1.x), p1.y + 3.0 / 7 * (p2.y - p1.y))
  test(tri, pt)
  echo()
  p3 = (-100 / 8, 100 / 6)
  tri = initTriangle(p1, p2, p3)
  test(tri, pt)
