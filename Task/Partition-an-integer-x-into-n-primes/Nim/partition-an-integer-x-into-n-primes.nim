import math, sugar

const N = 100_000

# Fill a sieve of Erathostenes.
var isPrime {.noInit.}: array[2..N, bool]
for item in isPrime.mitems: item = true
for n in 2..int(sqrt(N.toFloat)):
  if isPrime[n]:
    for k in countup(n * n, N, n):
      isPrime[k] = false

# Build list of primes.
let primes = collect(newSeq):
               for n in 2..N:
                 if isPrime[n]: n


proc partition(n, k: int; start = 0): seq[int] =
  ## Partition "n" in "k" primes starting at position "start" in "primes".
  ## Return the list of primes or an empty list if partitionning is impossible.

  if k == 1:
    return if isPrime[n] and n >= primes[start]: @[n] else: @[]

  for i in start..primes.high:
    let a = primes[i]
    if n - a <= 1: break
    result = partition(n - a, k - 1, i + 1)
    if result.len != 0:
      return a & result


when isMainModule:

  import strutils

  func plural(k: int): string =
    if k <= 1: "" else: "s"

  for (n, k) in [(99809, 1), (18, 2), (19, 3), (20, 4),
                (2017, 24), (22699, 1), (22699, 2),
                (22699, 3), (22699, 4), (40355, 3)]:
    let part = partition(n, k)
    if part.len == 0:
      echo n, " cannot be partitionned into ", k, " prime", plural(k)
    else:
      echo n, " = ", part.join(" + ")
