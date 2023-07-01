import math, strformat
import bignum

func solvePell(n: int): (Int, Int) =
  let x = newInt(sqrt(n.toFloat).int)
  var (y, z, r) = (x, newInt(1), x shl 1)
  var (e1, e2) = (newInt(1), newInt(0))
  var (f1, f2) = (newInt(0), newInt(1))

  while true:
    y = r * z - y
    z = (n - y * y) div z
    r = (x + y) div z

    (e1, e2) = (e2, e1 + e2 * r)
    (f1, f2) = (f2, f1 + f2 * r)

    let (a, b) = (f2 * x + e2, f2)
    if a * a - n * b * b == 1:
      return (a, b)

for n in [61, 109, 181, 277]:
  let (x, y) = solvePell(n)
  echo &"x² - {n:3} * y² = 1 for (x, y) = ({x:>21}, {y:>19})"
