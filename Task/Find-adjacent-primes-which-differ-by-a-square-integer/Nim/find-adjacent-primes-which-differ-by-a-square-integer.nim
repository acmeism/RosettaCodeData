import math

proc isPrime(n: Natural): bool =
  if n < 2:
    return false
  elif n == 2:
    return true
  else:
    for i in 2..int(sqrt(float(n))) + 1:
      if n mod i == 0:
        return false
    return true

proc isSquare(n: Natural): bool =
  return int(sqrt(float(n))) * int(sqrt(float(n))) == n

var primes: seq[int]

for i in 2..<1000000:
  if i.isPrime: primes &= i

for idx in 1..<primes.len:
  var diff = primes[idx] - primes[idx - 1]
  if diff > 36 and diff.isSquare:
    echo primes[idx - 1], " and ", primes[idx], ": ", "difference = ", diff
