import std/[math, strformat, strutils]

const Lim = 10_000_000

# Sieve of Eratosthenes storing only values for odd numbers starting at 3.
type Sieve = object
  data: array[0..((Lim - 3) div 2), bool]

proc `[]`(sieve: Sieve; idx: int): bool =
  ## Return the value at given index in a Sieve object.
  assert idx in 3..<Lim and idx mod 2 == 1, &"Invalid index: {idx}"
  sieve.data[(idx - 3) div 2]

proc `[]=`(sieve: var Sieve; idx: int; val: bool) =
  ## Set the value at given index in a Sieve object.
  assert idx in 3..<Lim and idx mod 2 == 1, &"Invalid index: {idx}"
  sieve.data[(idx - 3) div 2] = val


proc initSieve(): Sieve =
  ## Initialize a sieve.
  result.data = arrayWith(true, Sieve.data.len)
  var n = 3
  while n * n < Lim:
    if result[n]:
      for k in countup(n * n, Lim, 2 * n):
        result[k] = false
    inc n, 2

let isPrime = initSieve()


iterator twinPrimes(sieve: Sieve): (int, int) =
  ## Yield the successive twin primes.
  var n = 3
  while n < Lim - 2:
    if isPrime[n] and isPrime[n + 2]:
      yield (n, n + 2)
    inc n, 2


proc sqrt(n: int): int =
  ## Return the square root of "n" or -1 if it is not square.
  result = sqrt(n.toFloat).int
  if n != result * result:
    result = -1


var count = 0
var line = ""
for (p1, p2) in twinPrimes(isPrime):
  let r = sqrt(p1 + p2)
  if r >= 0:
    line.addSep "     "
    line.add align(&"{p1} + {p2} = {r}²", 26)
    inc count
    if count mod 3 == 0:
      echo line
      line.reset()
