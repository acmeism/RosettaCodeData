import std/strformat

type
  Point = tuple[x, y: float]
  QuadSpline = tuple[c0, c1, c2: float]   # Non-parametric spline.
  QuadCurve = tuple[x, y: QuadSpline]     # Planar parametric spline.


func subdivideQuadSpline(q: QuadSpline; t: float; u, v: var QuadSpline) =
  ## Subdivision by de Casteljau's algorithm.
  let s = 1.0 - t
  u.c0 = q.c0
  v.c2 = q.c2
  u.c1 = s * q.c0 + t * q.c1
  v.c1 = s * q.c1 + t * q.c2
  u.c2 = s * u.c1 + t * v.c1
  v.c0 = u.c2

func subdivideQuadCurve(q: QuadCurve; t: float; u, v: var QuadCurve) =
  subdivideQuadSpline(q.x, t, u.x, v.x)
  subdivideQuadSpline(q.y, t, u.y, v.y)

# It is assumed that xa0 <= xa1, ya0 <= ya1, xb0 <= xb1, and yb0 <= yb1.
func rectsOverlap(xa0, ya0, xa1, ya1, xb0, yb0, xb1, yb1: float): bool =
  xb0 <= xa1 and xa0 <= xb1 and yb0 <= ya1 and ya0 <= yb1

func max(x, y, z: float): float = max(max(x, y), z)
func min(x, y, z: float): float = min(min(x, y), z)

# This accepts the point as an intersection if the boxes are small enough.
func testIntersect(p, q: QuadCurve; tol: float; exclude, accept: var bool; intersect: var Point) =
  let
    pxmin = min(p.x.c0, p.x.c1, p.x.c2)
    pymin = min(p.y.c0, p.y.c1, p.y.c2)
    pxmax = max(p.x.c0, p.x.c1, p.x.c2)
    pymax = max(p.y.c0, p.y.c1, p.y.c2)

    qxmin = min(q.x.c0, q.x.c1, q.x.c2)
    qymin = min(q.y.c0, q.y.c1, q.y.c2)
    qxmax = max(q.x.c0, q.x.c1, q.x.c2)
    qymax = max(q.y.c0, q.y.c1, q.y.c2)

  exclude = true
  accept = false
  if rectsOverlap(pxmin, pymin, pxmax, pymax, qxmin, qymin, qxmax, qymax):
    exclude = false
    let xmin = max(pxmin, qxmin)
    let xmax = min(pxmax, pxmax)
    assert xmin <= xmax, &"Assertion failure: {xmin} <= {xmax}"
    if xmax - xmin <= tol:
      let ymin = max(pymin, qymin)
      let ymax = min(pymax, qymax)
      assert ymin <= ymax, &"Assertion failure: {ymin} <= {ymax}"
      if ymax - ymin <= tol:
          accept = true
          intersect = (0.5 * xmin + 0.5 * xmax, 0.5 * ymin + 0.5 * ymax)

func seemsToBeDuplicate(intersects: openArray[Point]; xy: Point; spacing: float): bool =
  var i = 0
  while not result and i != intersects.len:
    let pt = intersects[i]
    result = abs(pt.x - xy.x) < spacing and abs(pt.y - xy.y) < spacing
    inc i

func findIntersects(p, q: QuadCurve; tol, spacing: float): seq[Point] =
  var workload = @[(p: p, q: q)]

  # Quit looking after having emptied the workload.
  while workload.len > 0:
    var exclude, accept: bool
    var intersect: Point
    let work = workload.pop()
    testIntersect(work.p, work.q, tol, exclude, accept, intersect)
    if accept:
      # To avoid detecting the same intersection twice, require some
      # space between intersections.
      if not seemsToBeDuplicate(result, intersect, spacing):
          result.add intersect
    elif not exclude:
      var p0, p1, q0, q1: QuadCurve
      subdivideQuadCurve(work.p, 0.5, p0, p1)
      subdivideQuadCurve(work.q, 0.5, q0, q1)
      workload.add @[(p0, q0), (p0, q1), (p1, q0), (p1, q1)]

var p, q: QuadCurve
p.x = (-1.0, 0.0, 1.0)
p.y = (0.0, 10.0, 0.0)
q.x = (2.0, -8.0, 2.0)
q.y = (1.0, 2.0, 3.0)

const Tol = 0.0000001
const Spacing = Tol * 10

let intersects = findIntersects(p, q, Tol, Spacing)
for intersect in intersects:
  echo &"({intersect.x: .6f}, {intersect.y: .6f})"
