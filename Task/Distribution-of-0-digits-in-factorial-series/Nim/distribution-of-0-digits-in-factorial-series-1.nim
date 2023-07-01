import strutils, std/monotimes
import bignum

let t0 = getMonoTime()
var sum = 0.0
var f = newInt(1)
var lim = 100
for n in 1..10_000:
  f *= n
  let str = $f
  sum += str.count('0') / str.len
  if n == lim:
    echo n, ":\t", sum / float(n)
    lim *= 10
echo()
echo getMonoTime() - t0
