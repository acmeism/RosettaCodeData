import std/[math, strformat, strutils, monotimes, times]

const Max = 1_250_000_000   # To reach the 1_000_000_000th cube free number.


proc primeList(n: Natural): seq[Natural] =
  ## Return the list of primes in 2..n.
  assert n >= 3
  # Sieve with only odd numbers.
  var sieve = newSeq[bool]((n - 1) div 2)   # Initialized to "false" meaning not composite.
  var p = 3
  while p * p <= n:
    if not sieve[(p - 1) div 2]:
      # "p" is prime.
      for k in countup(p * p, n, 2 * p):
        sieve[(k - 3) div 2] = true
    inc p, 2
  # Build the list.
  result = @[2]
  for i, composite in sieve:
    if not composite:
      result.add 2 * i + 3

const Primes = primeList(cbrt(Max.toFloat).ceil.toInt)


proc cubeFreeSieve(n: Natural): seq[bool] =
  ## Build a sieve of cube free numbers.
  assert n >= 3

  # The sieve is initialized with "false" values meaning "cube free".
  result.setLen(n + 1)  # Element at index 0 is ignored.
  result[0] = true

  for p in Primes:
    let p3 = p * p * p
    for k in countup(p3, n, p3):
      result[k] = true


iterator cubeFreeNumbers(sieve: seq[bool]): (Natural, Natural) =
  ## Yield the successive cube numbers preceded by their rank.
  var rank = 1
  for n, withCube in sieve:
    if not withCube:
      yield (rank, n)
      inc rank


proc greatestPrimeFactor(n: Natural): Natural =
  ## Return the greatest prime factor of "n"
  if n == 1: return 1
  var n = n
  for p in Primes:
    if n < p: return
    if n mod p == 0:
      result = p
      n = n div p
      while n mod p == 0:
        n = n div p
  # Remaining "n" is prime.
  result = n


let t0 = getMonoTime()
let sieve = cubeFreeSieve(Max)
var lim = 1000
echo "100 first terms of a[n]:"
for i, n in cubeFreeNumbers(sieve):
  if i <= 100:
    let gpf = greatestPrimeFactor(n)
    stdout.write align($gpf, 4)
    if i mod 10 == 0: (echo(); if i == 100: echo())
  elif i == lim:
    let gpf = greatestPrimeFactor(n)
    echo &"a[{insertSep($i)}] = {insertSep($gpf)}"
    lim *= 10

echo "\nRun time: ", (getMonoTime() - t0).inMilliseconds / 1000
