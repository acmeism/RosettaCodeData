import strformat, strutils, times
import bignum

let
  One = newInt(1)
  Two = newInt(2)
  Three = newInt(3)

proc lucas(n: Int): Int =

  proc inner(n: Int): (Int, Int) =
    if n.isZero: return (newInt(0), newInt(1))
    var t = n shr 1
    var (u, v) = inner(t)
    t = n and Two
    let q = t - One
    var r = newInt(0)
    u *= u
    v *= v
    t = n and One
    if t == One:
      t = (u - q) * Two
      r = v * Three
      result = (u + v, r - t)
    else:
      t = u * Three
      r = v + q
      r *= Two
      result = (r - t, u + v)

  var t = n shr 1
  let (u, v) = inner(t)
  let l = v * Two - u
  t = n and One
  if t == One:
    let q = n and Two - One
    return v * l + q

  return u * l

let start = now()

var n: Int
var i = 10
while i <= 10_000_000:
  n = newInt(i)
  let s = $lucas(n)

  echo &"The digits of the {($i).insertSep}th Fibonacci number ({($s.len).insertSep}) are:"
  if s.len > 20:
    echo &"  First 20 : {s[0..19]}"
    if s.len < 40:
      echo &"  Final {s.len-20:<2} : {s[20..^1]}"
    else:
      echo &"  Final 20 : {s[^20..^1]}"
  else:
    echo &"  All {s.len:<2}   : {s}"
  echo()
  i *= 10

for e in [culong 16, 32]:
  n = One shl e
  let s = $lucas(n)
  echo &"The digits of the 2^{e}th Fibonacci number ({($s.len).insertSep}) are:"
  echo &"  First 20 : {s[0..19]}"
  echo &"  Final 20 : {s[^20..^1]}"
  echo()

echo &"Took {now() - start}"
