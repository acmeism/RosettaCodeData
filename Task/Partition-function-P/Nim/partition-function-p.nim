import sequtils, strformat, times
import bignum

func partitions(n: int): Int =
  var p = newSeqWith(n + 1, newInt())
  p[0] = newInt(1)
  for i in 1..n:
    var k = 1
    while true:
      var j = k * (3 * k - 1) div 2
      if j > i: break
      if (k and 1) != 0:
        inc p[i], p[i - j]
      else:
        dec p[i], p[i - j]
      j = k * (3 * k + 1) div 2
      if j > i: break
      if (k and 1) != 0:
        inc p[i], p[i - j]
      else:
        dec p[i], p[i - j]
      inc k
  result = p[n]

let t0 = cpuTime()
echo partitions(6666)
echo &"Elapsed time: {(cpuTime() - t0) * 1000:.2f} ms"
