import math, strutils

const Eps = 1e-14

type Point = tuple[x, y: float]

func `$`(p: Point): string =
  let x = if p.x == 0.0: 0.0 else: p.x
  let y = if p.y == 0.0: 0.0 else: p.y
  "($1, $2)".format(x, y)


func intersects(p1, p2, cp: Point; r: float; segment: bool): seq[Point] =
  let
    (x0, y0) = cp
    (x1, y1) = p1
    (x2, y2) = p2
    A = y2 - y1
    B = x1 - x2
    C = x2 * y1 - x1 * y2
  var
    a = A^2 + B^2
    b, c: float
    bnz = true
  if abs(B) >= Eps:
    b = 2 * (A * C + A * B * y0 - B^2 * x0)
    c = C^2 + 2 * B * C * y0 - B^2 * (r^2 - x0^2 - y0^2)
  else:
    b = 2 * (B * C + A * B * x0 - A^2 * y0)
    c = C^2 + 2 * A * C * x0 - A^2 * (r^2 - x0^2 - y0^2)
    bnz = false
  let d = b^2 - 4 * a * c
  if d < 0: return  # Line & circle don't intersect.

  func within(x, y: float): bool =
    ## Checks whether a point is within a segment.
    let
      d1 = sqrt((x2 - x1)^2 + (y2 - y1)^2)    # Distance between end-points.
      d2 = sqrt((x - x1)^2 + (y - y1)^2)      # Distance from point to one end.
      d3 = sqrt((x2 - x)^2 + (y2 - y)^2)      # Distance from point to other end.
      delta = d1 - d2 - d3
    result = abs(delta) < Eps                 # True if delta is less than a small tolerance.

  var x, y: float
  template fx: float = -(A * x + C) / B
  template fy: float = -(B * y + C) / A
  template rxy() =
    if not segment or within(x, y):
      result.add (x, y)

  if d == 0:
    # Line is tangent to circle, so just one intersect at most.
    if bnz:
      x = -b / (2 * a)
      y = fx()
      rxy()
    else:
      y = -b / (2 * a)
      x = fy()
      rxy()
  else:
    # Two intersects at most.
    let d = sqrt(d)
    if bnz:
      x = (-b + d) / (2 * a)
      y = fx()
      rxy()
      x = (-b - d) / (2 * a)
      y = fx()
      rxy()
    else:
      y = (-b + d) / (2 * a)
      x = fy()
      rxy()
      y = (-b - d) / (2 * a)
      x = fy()
      rxy()


when isMainModule:

  var cp: Point = (3.0, -5.0)
  var r = 3.0
  echo "The intersection points (if any) between:"
  echo "\n  A circle, center (3, -5) with radius 3, and:"
  echo "\n    a line containing the points (-10, 11) and (10, -9) is/are:"
  echo "     ", intersects((-10.0, 11.0), (10.0, -9.0), cp, r, false)
  echo "\n    a segment starting at (-10, 11) and ending at (-11, 12) is/are"
  echo "     ", intersects((-10.0, 11.0), (-11.0, 12.0), cp, r, true)
  echo "\n    a horizontal line containing the points (3, -2) and (7, -2) is/are:"
  echo "     ", intersects((3.0, -2.0), (7.0, -2.0), cp, r, false)
  cp = (0.0, 0.0)
  r = 4.0
  echo "\n  A circle, center (0, 0) with radius 4, and:"
  echo "\n    a vertical line containing the points (0, -3) and (0, 6) is/are:"
  echo "     ", intersects((0.0, -3.0), (0.0, 6.0), cp, r, false)
  echo "\n    a vertical segment starting at (0, -3) and ending at (0, 6) is/are:"
  echo "     ", intersects((0.0, -3.0), (0.0, 6.0), cp, r, true)
  cp = (4.0, 2.0)
  r = 5.0
  echo "\n  A circle, center (4, 2) with radius 5, and:"
  echo "\n    a line containing the points (6, 3) and (10, 7) is/are:"
  echo "     ", intersects((6.0, 3.0), (10.0, 7.0), cp, r, false)
  echo "\n    a segment starting at (7, 4) and ending at (11, 8) is/are:"
  echo "     ", intersects((7.0, 4.0), (11.0, 8.0), cp, r, true)
