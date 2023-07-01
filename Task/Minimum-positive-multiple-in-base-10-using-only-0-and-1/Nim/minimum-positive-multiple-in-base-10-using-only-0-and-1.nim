import sequtils, strformat, strutils, times
import bignum


func b10(n: int64): string =
  doAssert n > 0, "Argument must be positive."

  if n == 1: return "1"
  var pow, val = newSeq[int64](n + 1)
  var ten = 1i64

  for x in 1i64..val.high:
    val[x] = ten
    for i in 0..n:
      if pow[i] != 0 and pow[i] != x:
        let k = (ten + i) mod n
        if pow[k] == 0: pow[k] = x
    if pow[ten] == 0: pow[ten] = x
    ten = 10 * ten mod n
    if pow[0] != 0: break

  if pow[0] == 0:
    raise newException(ValueError, "Can’t do it!")

  # Build result string.
  var x = n
  var count = 0'i64
  while x != 0:
    let pm = pow[x mod n]
    if count > pm:
      result.add repeat('0', count - pm)
    count = pm - 1
    result.add '1'
    x = (n + x - val[pm]) mod n
  result.add repeat('0', count)


const Data = toSeq(1..10) & toSeq(95..105) &
             @[297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878]

let t0 = cpuTime()
for val in Data:
  let res = b10(val)
  let m = newInt(res)
  if m mod val != 0: echo &"Wrong result for {val}."
  else: echo &"{val:4} × {m div val:<24} = {res}"
echo &"Time: {cpuTime() - t0:.3f} s"
