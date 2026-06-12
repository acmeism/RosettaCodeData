import strformat

const
  N = 5500 - 1
  Max = N + 6

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

echo "   p  p+2  p+6"
var count = 0
for n in countup(3, N, 2):
  if n.isPrime and (n + 2).isPrime and (n + 6).isPrime:
    echo &"{n:4} {n+2:4} {n+6:4}"
    inc count

echo &"\nFound {count} primes triplets for p < {N+1}."
