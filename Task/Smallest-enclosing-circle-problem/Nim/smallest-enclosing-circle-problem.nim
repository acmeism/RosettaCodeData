import math, random, strutils

type
  Point = tuple[x, y: float]
  Circle = tuple[c: Point; r: float]


func `$`(p: Point): string =
  ## Return the string representation of a point.
  "($1, $2)".format(p.x, p.y)


func dist(a, b: Point): float =
  ## Return the distance between two points.
  hypot(a.x - b.x, a.y - b.y)


func getCircleCenter(bx, by, cx, cy: float): Point =
  ## Return the center of a circle defined by three points.
  let
    b = bx * bx + by * by
    c = cx * cx + cy * cy
    d = bx * cy - by * cx
  result = ((cy * b - by * c) / (2 * d), (bx * c - cx * b) / (2 * d))

func contains(ci: Circle; p: Point): bool =
  ## Return whether a circle contains the point 'p'.
  ## Used by 'in' and 'notin'.
  dist(ci.c, p) <= ci.r


func contains(ci: Circle; ps: seq[Point]): bool =
  ## Return whether a circle contains a slice of points.
  ## Used by 'in'.
  for p in ps:
    if p notin ci: return false
  result = true


func `$`(ci: Circle): string =
  ## Return the string representation of a circle.
  "Center $1, Radius $2".format(ci.c, ci.r)


func circleFrom3(a, b, c: Point): Circle =
  ## Return the smallest circle that intersects three points.
  var i = getCircleCenter(b.x - a.x, b.y - a.y, c.x - a.x, c.y - a.y)
  i.x += a.x
  i.y += a.y
  result = (c: i, r: dist(i, a))


func circleFrom2(a, b: Point): Circle =
  ## Return the smallest circle that intersects two points.
  let c = ((a.x + b.x) * 0.5, (a.y + b.y) * 0.5)
  result = (c: c, r: dist(a, b) * 0.5)


func secTrivial(rs: seq[Point]): Circle =
  ## Return the smallest enclosing circle for n <= 3.
  case rs.len
  of 0: return ((0.0, 0.0), 0.0)
  of 1: return (rs[0], 0.0)
  of 2: return circleFrom2(rs[0], rs[1])
  of 3: discard
  else: raise newException(ValueError, "There shouldn't be more than three points.")

  # Three points.
  for i in 0..1:
    for j in (i + 1)..2:
      let c = circleFrom2(rs[i], rs[j])
      if rs in c: return c
  result = circleFrom3(rs[0], rs[1], rs[2])


proc welzl(ps: var seq[Point]; rs: seq[Point]; n: int): Circle =
  ## Helper function for Welzl method.
  var rc = rs
  if n == 0 or rc.len == 3: return secTrivial(rc)
  let idx = rand(n-1)
  let p = ps[idx]
  swap ps[idx], ps[n-1]
  let d = welzl(ps, rc, n-1)
  if p in d: return d
  rc.add p
  result = welzl(ps, rc, n-1)


proc welzl(ps: seq[Point]): Circle =
  # Applies the Welzl algorithm to find the SEC.
  var pc = ps
  pc.shuffle()
  result = welzl(pc, @[], pc.len)


when isMainModule:
  randomize()
  const Tests = [@[(0.0, 0.0), (0.0, 1.0), (1.0, 0.0)],
                 @[(5.0, -2.0), (-3.0, -2.0), (-2.0, 5.0), (1.0, 6.0), (0.0, 2.0)]]

  for test in Tests:
    echo welzl(test)
