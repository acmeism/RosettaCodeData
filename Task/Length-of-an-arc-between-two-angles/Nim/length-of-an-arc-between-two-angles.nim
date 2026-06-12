import math, strformat

const TwoPi = 2 * Pi

func arcLength(r, a, b: float): float =
  ## Return the length of the major arc in a circle of radius "r"
  ## between angles "a" and "b" expressed in radians.
  let d = abs(a - b) mod TwoPi
  result = r * (if d >= Pi: d else: TwoPi - d)

echo &"Arc length: {arcLength(10, degToRad(10.0), degToRad(120.0)):.5f}"
