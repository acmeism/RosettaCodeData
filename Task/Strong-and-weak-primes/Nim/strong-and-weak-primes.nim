import math, strutils

const
  M = 10_000_000
  N = M + 19      # Maximum value for sieve.

# Fill sieve of Erathosthenes.
var comp: array[2..N, bool]   # True means composite; default is prime.
for n in countup(3, sqrt(N.toFloat).int, 2):
  if not comp[n]:
    for k in countup(n * n, N, 2 * n):
      comp[k] = true

# Build list of primes.
var primes = @[2]
for n in countup(3, N, 2):
  if not comp[n]:
    primes.add n
if primes[^1] < M: quit "Not enough primes: please, increase value of N."

# Build lists of strong and weak primes.
var strongPrimes, weakPrimes: seq[int]
for i in 1..<primes.high:
  let p = primes[i]
  if p shl 1 > primes[i - 1] + primes[i + 1]:
    strongPrimes.add p
  elif p shl 1 < primes[i - 1] + primes[i + 1]:
    weakPrimes.add p


when isMainModule:

  proc count(list: seq[int]; max: int): int =
    ## Return the count of values less than "max".
    for p in list:
      if p >= max: break
      inc result

  echo "First 36 strong primes:"
  echo "  ", strongPrimes[0..35].join(" ")
  echo "Count of strong primes below 1_000_000: ", strongPrimes.count(1_000_000)
  echo "Count of strong primes below 10_000_000: ", strongPrimes.count(10_000_000)
  echo()

  echo "First 37 weak primes:"
  echo "  ", weakPrimes[0..36].join(" ")
  echo "Count of weak primes below 1_000_000: ", weakPrimes.count(1_000_000)
  echo "Count of weak primes below 10_000_000: ", weakPrimes.count(10_000_000)
