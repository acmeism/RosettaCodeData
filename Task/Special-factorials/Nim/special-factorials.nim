import math, strformat, strutils, sugar
import bignum

proc pow(a: int; n: Int): Int =
  ## Compute a^n for "n" big integer.
  var n = n
  var a = newInt(a)
  if a > 0:
    result = newInt(1)
    # Start with Int values for "n".
    while not n.isZero:
      if (n and 1) != 0:
        result *= a
      n = n shr 1
      a *= a

func sf(n: Natural): Int =
  result = newInt(1)
  for i in 2..n:
    result *= fac(i)

func hf(n: Natural): Int =
  result = newInt(1)
  for i in 2..n:
    result *= pow(i, uint(i))

func af(n: Natural): Int =
  result = newInt(0)
  var m = (n and 1) shl 1 - 1
  for i in 1..n:
    result += m * fac(i)
    m = -m

func ef(n: Natural): Int =
  result = newInt(1)
  for k in 2..n:
    result = pow(k, result)

func rf(n: int | Int): int =
  if n == 1: return 0
  result = 1
  var p = newInt(1)
  while p < n:
    inc result
    p *= result
  if p > n: result = -1

let sfs = collect(newSeq, for n in 0..9: sf(n))
echo &"First {sfs.len} superfactorials: ", sfs.join(" ")

let hfs = collect(newSeq, for n in 0..9: hf(n))
echo &"First {hfs.len} hyperfactorials: ", hfs.join(" ")

let afs = collect(newSeq, for n in 0..9: af(n))
echo &"First {afs.len} alternating factorials: ", afs.join(" ")

let efs = collect(newSeq, for n in 0..4: ef(n))
echo &"First {efs.len} exponential factorials: ", efs.join(" ")

echo "\nNumber of digits of ef(5): ", len($ef(5))

echo "\nReverse factorials:"
for n in [1, 2, 6, 24, 119, 120, 720, 5040, 40320, 362880, 3628800]:
  let r = rf(n)
  echo &"{n:7}: ", if r >= 0: &"{r:2}" else: "undefined"
