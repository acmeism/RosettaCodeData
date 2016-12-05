from math import nil

proc cube(x: float64) : float64 {.procvar.} =
  math.pow(x, 3)

proc cuberoot(x: float64) : float64 {.procvar.} =
  math.pow(x, 1/3)

proc compose[A](f: proc(x: A): A, g: proc(x: A): A) : (proc(x: A): A) =
  proc c(x: A): A {.closure.} =
    f(g(x))
  return c

proc sin(x: float64) : float64 {.procvar.} =
  math.sin(x)
proc asin(x: float64) : float64 {.procvar.}=
  math.arcsin(x)
proc cos(x: float64) : float64 {.procvar.} =
  math.cos(x)
proc acos(x: float64) : float64 {.procvar.} =
  math.arccos(x)

var fun = @[sin, cos, cube]
var inv = @[asin, acos, cuberoot]

for i in 0..2:
  echo $compose(inv[i], fun[i])(0.5)
