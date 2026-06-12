import math, strutils

const
  N1 = 499    # Limit for the primes.
  N2 = 999    # Limit for the reverses of primes.

# Sieve of Erathosthenes.
var composite: array[2..N2, bool]     # Default is false.
for p in 2..sqrt(N2.toFloat).int:
  if not composite[p]:
    for k in countup(p * p, N2, p):
      composite[k] = true

template isPrime(n: int): bool = not composite[n]

func reversed(n: int): int =
  var n = n
  while n != 0:
    result = 10 * result + n mod 10
    n = n div 10

var result: seq[int]
for n in 2..N1:
  if n.isPrime and reversed(n).isPrime:
    result.add n

for i, n in result:
  stdout.write ($n).align(3)
  stdout.write if (i + 1) mod 10 == 0: '\n' else: ' '
echo()
