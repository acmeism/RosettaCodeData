import strformat, strutils
import bignum

var k = 1u
var toFind = {0..50}
var results: array[0..50, uint]
while toFind.card > 0:
  let str = $(pow(newInt(k), k))
  for n in toFind:
    if str.find($n) >= 0:
      results[n] = k
      toFind.excl(n)
  inc k

echo "Smallest values of k such that k^k contains n:"
for n, k in results:
  stdout.write &"{n:2} → {k:<2}   ", if (n + 1) mod 9 == 0: '\n' else: ' '
echo()
