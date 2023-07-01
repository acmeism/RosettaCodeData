import sequtils, strutils, times
import bignum

iterator superDNumbers(d, maxCount: Positive): Natural =
  var count = 0
  var n = 2
  let e = culong(d)   # Bignum ^ requires a culong as exponent.
  let pattern = repeat(chr(d + ord('0')), d)
  while count != maxCount:
    if pattern in $(d * n ^ e):
      yield n
      inc count
    inc n, 1

let t0 = getTime()
for d in 2..9:
  echo "First 10 super-$# numbers:".format(d)
  echo toSeq(superDNumbers(d, 10)).join(" ")
echo "Time: ", getTime() - t0
