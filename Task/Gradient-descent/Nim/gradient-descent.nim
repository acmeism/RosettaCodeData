import math, strformat


func steepDescent(g: proc(x: openArray[float]): float;
                  gradG: proc(p: openArray[float]): seq[float];
                  x: var openArray[float]; alpha, tolerance: float) =
  let n = x.len
  var alpha = alpha
  var g0 = g(x)   # Initial estimate of result.

  # Calculate initial gradient.
  var fi = gradG(x)

  # Calculate initial norm.
  var delG = 0.0
  for i in 0..<n:
    delG += fi[i] * fi[i]
  delG = sqrt(delG)
  var b = alpha / delG

  # Iterate until value is <= tolerance.
  while delG > tolerance:
    # Calculate next value.
    for i in 0..<n:
      x[i] -= b * fi[i]

    # Calculate next gradient.
    fi = gradG(x)

    # Calculate next norm.
    delG = 0
    for i in 0..<n:
      delG += fi[i] * fi[i]
    delG = sqrt(delG)
    b = alpha / delG

    # Calculate next value.
    let g1 = g(x)

    # Adjust parameter.
    if g1 > g0: alpha *= 0.5
    else: g0 = g1


when isMainModule:

  func g(x: openArray[float]): float =
    ## Function for which minimum is to be found.
    (x[0]-1) * (x[0]-1) * exp(-x[1]*x[1]) + x[1] * (x[1]+2) * exp(-2*x[0]*x[0])

  func gradG(p: openArray[float]): seq[float] =
    ## Provides a rough calculation of gradient g(p).
    result = newSeq[float](p.len)
    let x = p[0]
    let y = p[1]
    result[0] = 2 * (x-1) * exp(-y*y) - 4 * x * exp(-2*x*x) * y * (y+2)
    result[1] = -2 * (x-1) * (x-1) * y * exp(-y*y) + 2 * (y+1) * exp(-2*x*x)

  const
    Tolerance = 0.0000006
    Alpha = 0.1

  var x = [0.1, -1.0]   # Initial guess of location of minimum.

  steepDescent(g, gradG, x, Alpha, Tolerance)
  echo "Testing steepest descent method:"
  echo &"The minimum is at x = {x[0]:.12f}, y = {x[1]:.12f} for which f(x, y) = {g(x):.12f}"
