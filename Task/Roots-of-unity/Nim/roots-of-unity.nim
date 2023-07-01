import complex, math, sequtils, strformat, strutils

proc roots(n: Positive): seq[Complex64] =
  for k in 0..<n:
    result.add rect(1.0, 2 * k.float * Pi / n.float)

proc toString(z: Complex64): string =
  &"{z.re:.3f} + {z.im:.3f}i"

for nr in 2..10:
  let result = roots(nr).map(toString).join(", ")
  echo &"{nr:2}: {result}"
