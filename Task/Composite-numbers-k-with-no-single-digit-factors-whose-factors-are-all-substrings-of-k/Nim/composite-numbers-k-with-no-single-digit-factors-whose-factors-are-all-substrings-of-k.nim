import std/[strformat, strutils]

const Max = 80_000_000  # Maximal value for composite number.

# Prime factors of odd numbers.
# If a number is prime, its factor list is empty.
var factors: array[0..(Max - 3) div 2, seq[uint32]]

template primeFactors(n: Natural): seq[uint32] =
  factors[(n - 3) shr 1]

# Build the list of factors.
for n in countup(3u32, Max div 11, 2):
  if primeFactors(n).len == 0:
    # "n" is prime.
    for k in countup(n + n + n, Max, 2 * n):
      primeFactors(k).add n

const N = 20  # Number of results.
var n = 11 * 11
var count = 0
while count < N:
  if primeFactors(n).len > 0:
    let nStr = $n
    block Check:
      for f in primeFactors(n):
        if f < 11 or $f notin nStr: break Check
      inc count
      echo &"{count:2}: {insertSep($n)}"
  inc n, 2
