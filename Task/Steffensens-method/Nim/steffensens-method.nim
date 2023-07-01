import std/[math, strformat]

proc aitken(f: proc(x: float): float; p0: float): float =
  let p1 = f(p0)
  let p2 = f(p1)
  let p1m0 = p1 - p0
  result = p0 - p1m0 * p1m0 / (p2 - 2 * p1 + p0)

proc steffensenAitken(f: proc(x: float): float; pinit, tol: float; maxiter: int): float =
  var p0 = pinit
  result = aitken(f, p0)
  var iter = 1
  while abs(result - p0) > tol and iter < maxiter:
    p0 = result
    result = aitken(f, p0)
    inc iter
  if abs(result - p0) > tol: return Nan

func deCasteljau(c0, c1, c2, t: float): float =
  let s = 1 - t
  let c01 = s * c0 + t * c1
  let c12 = s * c1 + t * c2
  result = s * c01 + t * c12

template xConvexLeftParabola(t: float): float =
  deCasteljau(2, -8, 2, t)

template yConvexRightParabola(t: float): float =
  deCasteljau(1, 2, 3, t)

func implicitEquation(x, y: float): float =
  5 * x * x + y - 5

func f(t: float): float =
  let x = xConvexLeftParabola(t)
  let y = yConvexRightParabola(t)
  result = implicitEquation(x, y) + t

var t0 = 0.0
var x, y: float
for i in 0..10:
  stdout.write &"t0 = {t0:0.1f} → "
  let t = steffensenAitken(f, t0, 0.00000001, 1000)
  if t.isNan:
    echo "no answer"
  else:
    x = xConvexLeftParabola(t);
    y = yConvexRightParabola(t);
    if abs(implicitEquation(x, y)) <= 0.000001:
      echo &"intersection at ({x:.6f}, {y:.6f})"
    else:
      echo "spurious solution"
  t0 += 0.1
