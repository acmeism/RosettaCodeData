import strformat

const
  N = 5999
  Max = 6003  # 5998 + 5.

# Sieve of Erathosthenes: false (default) is composite.
var composite: array[3..Max, bool]   # Ignore 2 as all primes should be odd.
var n = 3
while true:
  let n2 = n * n
  if n2 > Max: break
  if not composite[n]:
    for k in countup(n2, Max, 2 * n):
      composite[k] = true
  inc n, 2

template isPrime(n: int): bool = not composite[n]

echo "   n   n-1  n+3  n+5"
var count = 0
for n in countup(4, N, 2):
  if (n - 1).isPrime and (n + 3).isPrime and (n + 5).isPrime:
    echo &"{n:4}: {n-1:4} {n+3:4} {n+5:4}"
    inc count

echo &"\nFound {count} triplets for n < {N+1}."
