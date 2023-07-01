import math, strformat, strutils

const N = 1_000_000_000

proc sieve(n: Positive): seq[bool] =
  ## Build and fill a sieve of Erathosthenes.
  result.setLen(n + 1)  # Default to false which means prime.
  result[0] = true
  result[1] = true
  for n in countup(3, sqrt(N.toFloat).int, 2):
    if not result[n]:
      for k in countup(n * n, N, 2 * n):
        result[k] = true

let composite = sieve(N)

proc findTwins(composite: openArray[bool]) =
  var
    lim = 10
    count = 1     # Start with 3, 5 which is a special case.
    n = 7         # First prime congruent to 1 modulo 3.
  while true:
    if not composite[n] and not composite[n - 2]: inc count
    inc n, 6      # Next odd number congruent to 1 modulo 3.
    if n > lim:
      echo &"There are {insertSep($count)} pairs of twin primes under {insertSep($lim)}."
      lim *= 10
      if lim > N: break

composite.findTwins()
