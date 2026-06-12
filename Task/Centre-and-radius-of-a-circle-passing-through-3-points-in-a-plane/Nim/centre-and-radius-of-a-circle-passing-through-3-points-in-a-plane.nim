import std/[complex, math, strformat, strutils]

type Point = Complex64

proc point(x, y: float64): Point =
  ## Return a Point from x and y coordinates.
  complex64(x, y)


proc circleFromThreePoints(z1, z2, z3: Point): tuple[c: Point; r: float] =
  if (z1 == z2) or (z2 == z3) or (z3 == z1):
    raise newException(ValueError, &"Duplicate points: {z1}, {z2}, {z3}")

  let w = (z3 - z1) / (z2 - z1)

  if abs(w.im).almostEqual(0):
    raise newException(ValueError, &"Points are collinear: {z1}, {z2}, {z3}")

  result.c = (z2 - z1) * (w - abs(w)^2) / point(0, 2 * w.im) + z1  # Simplified denominator.
  result.r = abs(z1 - result.c)


let (center, radius) = circleFromThreePoints(point(22.83, 2.07),
                                             point(14.39, 30.24),
                                             point(33.65, 17.31))

echo &"centerpoint: ({round(center.re,2)}, {round(center.im, 2)})"
echo &"radius: {round(radius, 2)}"
