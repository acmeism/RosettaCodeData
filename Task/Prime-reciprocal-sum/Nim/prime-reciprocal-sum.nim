import std/strformat
import bignum

iterator a075442(): Int =
  let One = newRat(1)
  var sum = newRat(0)
  var p = newInt(0)
  while true:
    let q = reciprocal(One - sum)
    p = nextPrime(if q.isInt: q.num else: q.toInt + 1)
    yield p
    sum += newRat(1, p)

func compressed(str: string; size: int): string =
  ## Return a compressed value for long strings of digits.
  if str.len <= 2 * size: str
  else: &"{str[0..<size]}...{str[^size..^1]} ({str.len} digits)"

var count = 0
for p in a075442():
  inc count
  echo &"{count:2}: {compressed($p, 20)}"
  if count == 15: break
