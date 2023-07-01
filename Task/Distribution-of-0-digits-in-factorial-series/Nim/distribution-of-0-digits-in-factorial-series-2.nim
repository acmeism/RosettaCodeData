import strutils, std/monotimes
import bignum

let t0 = getMonoTime()
var sum = 0.0
var first = 0
var f = newInt(1)
var count0 = 0
for n in 1..<50_000:
  f *= n
  while f mod 10 == 0:    # Reduce the length of "f".
    f = f div 10
    inc count0
  let str = $f
  sum += (str.count('0') + count0) / (str.len + count0)
  if sum / float(n) < 0.16:
    if first == 0: first = n
  else:
    first = 0

echo "Permanently below 0.16 at n = ", first
echo "Execution time: ", getMonoTime() - t0
