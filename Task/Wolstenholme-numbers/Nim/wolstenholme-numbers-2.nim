import std/strformat
import bignum

iterator wolstenholme(): (int, Int) =
  var count = 0
  var k = 1
  var s = newRat(1)
  while true:
    inc count
    yield (count, s.num)
    inc k
    s += newRat(1, k * k)

var wprimes: seq[Int]
for (count, n) in wolstenholme():
  if wprimes.len < 15 and probablyPrime(n, 25) != 0:
    wprimes.add n
  if count in [500, 1000, 2500, 5000, 10000]:
    echo &"The {count}th Wolstenholme number has {len($n)} digits."
    if count == 10000: break

echo "\nDigit count of the first 15 Wolstenholme primes:"
for i in 0..14:
  echo &"{i + 1: >2}: {len($wprimes[i])}"
