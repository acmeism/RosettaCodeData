import strformat
import bignum

let ln2 = newInt("693147180559945309417232121458") / newInt("1000000000000000000000000000000")

iterator hickerson(): tuple[n: int; val: Rat] =
  ## Yield the hickerson series values as rational numbers.
  var
    n = 1
    num = 1
    denom = 2 * ln2 * ln2
  while true:
    yield (n, num / denom)
    inc n
    num *= n
    denom *= ln2

func fract(r: Rat): float =
  ## Return the fractional part of rational "r".
  ((r.num mod r.denom) / r.denom).toFloat

for i, val in hickerson():
  let f = val.fract
  let s = if int(10 * f) in {0, 9}: "" else: "not "
  echo &"Fractional part of h({i}) is {f:.5f}..., so h({i}) is {s}nearly an integer."
  if i == 17: break
