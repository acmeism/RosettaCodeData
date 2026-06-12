import std/strformat

func isPrime(n: Positive): bool =
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var k = 5
  var delta = 2
  while k * k <= n:
    if n mod k == 0: return false
    inc k, delta
    delta = 6 - delta
  result = true

echo "Double twin primes under 1000:"
for n in countup(3, 991, 2):
  if isPrime(n) and isPrime(n + 2) and isPrime(n + 6) and isPrime(n + 8):
    echo &"({n:>3}, {n+2:>3}, {n+6:>3}, {n+8:>3})"
