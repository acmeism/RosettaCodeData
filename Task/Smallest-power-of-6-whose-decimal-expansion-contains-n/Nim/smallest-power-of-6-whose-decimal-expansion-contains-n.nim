import strformat, strutils
import bignum

var toFind = {0..21}
var results: array[0..21, (int, string)]
var p = newInt(1)
var k = 0
while toFind.card > 0:
  let str = $p
  for n in toFind:
    if str.find($n) >= 0:
      results[n] = (k, str)
      toFind.excl(n)
  p *= 6
  inc k

echo "Smallest values of k such that 6^k contains n:"
for n, (k, s) in results:
  echo &"{n:2}:  6^{k:<2} = {s}"
