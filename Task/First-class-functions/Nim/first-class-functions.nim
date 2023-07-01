from math import nil  # Require qualifier to access functions.

type MF64 = proc(x: float64): float64

proc cube(x: float64) : float64 =
  math.pow(x, 3)

proc cuberoot(x: float64) : float64 =
  math.pow(x, 1/3)

proc compose[A](f: proc(x: A): A, g: proc(x: A): A) : (proc(x: A): A) =
  proc c(x: A): A =
    f(g(x))
  return c

proc sin(x: float64) : float64 =
  math.sin(x)

proc acos(x: float64) : float64 =
  math.arccos(x)

var fun = @[sin, math.cos, cube]
var inv = @[MF64 math.arcsin, acos, cuberoot]

for i in 0..2:
  echo compose(inv[i], fun[i])(0.5)
