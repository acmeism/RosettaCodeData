import std/[math, monotimes, strutils, times]
import integers

func dominoTilingCount(m, n: Positive): int =
  var prod = 1.0
  for j in 1..((m + 1) div 2):
    for k in 1..((n + 1) div 2):
      let cm = cos(PI * (j / (m + 1)))
      let cn = cos(PI * (k / (n + 1)))
      prod *= (cm * cm + cn * cn) * 4
  result = int(prod)

let
  start = getMonoTime()
  arrang = dominoTilingCount(7, 8)
  perms = factorial(28)
  flips = 1 shl 28

echo "Arrangements ignoring values: ", insertSep($arrang)
echo "Permutations of 28 dominos: ", insertSep($perms)
echo "Permuted arrangements ignoring flipping dominos: ", insertSep($(perms * arrang))
echo "Possible flip configurations: ", insertSep($flips)
echo "Possible permuted arrangements with flips: ", insertSep($(perms * flips * arrang))
echo "\nTook $# µs.".format((getMonoTime() - start).inMicroseconds)
