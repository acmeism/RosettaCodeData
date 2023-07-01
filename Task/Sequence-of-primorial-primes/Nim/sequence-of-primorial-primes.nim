import strutils, sugar
import bignum

## Run a sieve of Erathostenes.
const N = 4000
var isComposite: array[2..N, bool]  # False (default) means "is prime".
for n in 2..isComposite.high:
  if not isComposite[n]:
    for k in countup(n * n, N, n):
      isComposite[k] = true

# Collect the list of primes.
let primes = collect(newSeq):
               for n, comp in isComposite:
                 if not comp:
                   n

iterator primorials(): Int =
  ## Yield the successive primorial numbers.
  var result = newInt(1)
  for prime in primes:
    result *= prime
    yield result

template isPrime(n: Int): bool =
  ## Return true if "n" is certainly or probably prime.
  ## Use the probabilistic test provided by "bignum" (i.e. "gmp" probabilistic test).
  probablyPrime(n, 25) != 0

func isPrimorialPrime(n: Int): bool =
  ## Return true if "n" is a primorial prime.
  (n - 1).isPrime or (n + 1).isPrime


const Lim = 20                        # Number of indices to keep.
var idx = 0                           # Primorial index.
var indices = newSeqOfCap[int](Lim)   # List of indices.

for p in primorials():
  inc idx
  if p.isPrimorialPrime():
    indices.add idx
    if indices.len == LIM: break

echo indices.join(" ")
