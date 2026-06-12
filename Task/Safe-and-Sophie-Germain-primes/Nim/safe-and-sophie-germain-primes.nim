import std/strutils

func isPrime(n: Natural): bool =
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

iterator sophieGermainPrimes(): int =
  var n = 2
  while true:
    if isPrime(n) and isPrime(2 * n + 1):
      yield n
    inc n

echo "First 50 Sophie Germain primes:"
var count = 0
for n in sophieGermainPrimes():
  inc count
  stdout.write align($n, 4)
  stdout.write if count mod 10 == 0: '\n' else: ' '
  if count == 50: break
