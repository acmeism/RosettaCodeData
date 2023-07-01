import strformat

type Point = tuple[x, y: float]

type Triangle = array[3, Point]

func `$`(p: Point): string =
  fmt"({p.x:.1f}, {p.y:.1f})"

func `$`(t: Triangle): string =
  fmt"Triangle {t[0]}, {t[1]}, {t[2]}"

func det2D(t: Triangle): float =
  t[0].x * (t[1].y - t[2].y) +
  t[1].x * (t[2].y - t[0].y) +
  t[2].x * (t[0].y - t[1].y)

func checkTriWinding(t: var Triangle; allowReversed: bool) =
  let det = t.det2D()
  if det < 0:
    if allowReversed:
      swap t[1], t[2]
    else:
      raise newException(ValueError, "Triangle has wrong winding direction.")

func boundaryCollideChk(t: Triangle; eps: float): bool =
  t.det2D() < eps

func boundaryDoesntCollideChk(t: Triangle; eps: float): bool =
  t.det2D() <= eps

func triTri2D(t1, t2: var Triangle; eps = 0.0;
              allowReversed = false; onBoundary = true): bool =

  # Triangles must be expressed anti-clockwise.
  t1.checkTriWinding(allowReversed)
  t2.checkTriWinding(allowReversed)

  # "onBoundary" determines whether points on boundary are considered as colliding or not.
  let chkEdge = if onBoundary: boundaryCollideChk else: boundaryDoesntCollideChk

  # For each edge E of t1.
  for i in 0..2:
    let j = (i + 1) mod 3
    # Check that all points of t2 lay on the external side of edge E.
    # If they do, the triangles do not overlap.
    if chkEdge([t1[i], t1[j], t2[0]], eps) and
       chkEdge([t1[i], t1[j], t2[1]], eps) and
       chkEdge([t1[i], t1[j], t2[2]], eps):
         return false

  # For each edge E of t2.
  for i in 0..2:
    let j = (i + 1) mod 3
    # Check that all points of t1 lay on the external side of edge E.
    # If they do, the triangles do not overlap.
    if chkEdge([t2[i], t2[j], t1[0]], eps) and
       chkEdge([t2[i], t2[j], t1[1]], eps) and
       chkEdge([t2[i], t2[j], t1[2]], eps):
         return false

  # The triangles overlap.
  result = true


when isMainModule:

  var t1: Triangle = [(0.0, 0.0), (5.0, 0.0), (0.0, 5.0)]
  var t2: Triangle = [(0.0, 0.0), (5.0, 0.0), (0.0, 6.0)]
  echo t1, " and\n", t2
  var overlapping = triTri2D(t1, t2, 0, false, true)
  echo if overlapping: "overlap\n" else: "do not overlap\n"

  # Need to allow reversed for this pair to avoid exception.
  t1 = [(0.0, 0.0), (5.0, 0.0), (5.0, 0.0)]
  t2 = t1
  echo t1, " and\n", t2
  overlapping = triTri2D(t1, t2, 0, true, true)
  echo if overlapping: "overlap (reversed)\n" else: "do not overlap\n"

  t1 = [(0.0, 0.0), (5.0, 0.0), (0.0, 5.0)]
  t2 = [(-10.0, 0.0), (-5.0, 0.0), (-1.0, 6.0)]
  echo t1, " and\n", t2
  overlapping = triTri2D(t1, t2, 0, false, true)
  echo if overlapping: "overlap\n" else: "do not overlap\n"

  t1[2] = (2.5, 5.0)
  t2 = [(0.0, 4.0), (2.5, -1.0), (5.0, 4.0)]
  echo t1, " and\n", t2
  overlapping = triTri2D(t1, t2, 0, false, true)
  echo if overlapping: "overlap\n" else: "do not overlap\n"

  t1 = [(0.0, 0.0), (1.0, 1.0), (0.0, 2.0)]
  t2 = [(2.0, 1.0), (3.0, 0.0), (3.0, 2.0)]
  echo t1, " and\n", t2
  overlapping = triTri2D(t1, t2, 0, false, true)
  echo if overlapping: "overlap\n" else: "do not overlap\n"

  t2 = [(2.0, 1.0), (3.0, -2.0), (3.0, 4.0)]
  echo t1, " and\n", t2
  overlapping = triTri2D(t1, t2, 0, false, true)
  echo if overlapping: "overlap\n" else: "do not overlap\n"

  t1 = [(0.0, 0.0), (1.0, 0.0), (0.0, 1.0)]
  t2 = [(1.0, 0.0), (2.0, 0.0), (1.0, 1.1)]
  echo t1, " and\n", t2
  echo "which have only a single corner in contact, if boundary points collide"
  overlapping = triTri2D(t1, t2, 0, false, true)
  echo if overlapping: "overlap\n" else: "do not overlap\n"

  echo t1, " and\n", t2
  echo "which have only a single corner in contact, if boundary points do not collide"
  overlapping = triTri2D(t1, t2, 0, false, false)
  echo if overlapping: "overlap\n" else: "do not overlap\n"
