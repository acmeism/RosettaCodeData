import strutils, sequtils
import bignum

const
  Max = 10
  Factors: array[3..Max, int] = [1, 1, 2, 4, 8, 16, 32, 64]   # 1 for n=3 then 2^(n-4).
  FirstPrimes = [3, 5, 7, 11, 13, 17, 19, 23]

#---------------------------------------------------------------------------------------------------

iterator factors(n, m: Natural): Natural =
  ## Yield the factors of U(n, m).

  yield 6 * m + 1
  yield 12 * m + 1
  var k = 2
  for _ in 1..(n - 2):
    yield 9 * k * m + 1
    inc k, k

#---------------------------------------------------------------------------------------------------

proc mayBePrime(n: int): bool =
  ## First primality test.

  if n < 23: return true

  for p in FirstPrimes:
    if n mod p == 0:
      return false

  result = true

#---------------------------------------------------------------------------------------------------

proc isChernick(n, m: Natural): bool =
  ## Check if U(N, m) if a Chernick-Carmichael number.

  # Use the first and quick test.
  for factor in factors(n, m):
    if not factor.mayBePrime():
      return false

  # Use the slow probability test (need to use a big int).
  for factor in factors(n, m):
    if probablyPrime(newInt(factor), 25) == 0:
      return false

  result = true

#---------------------------------------------------------------------------------------------------

proc a(n: Natural): tuple[m: Natural, factors: seq[Natural]] =
  ## For a given "n", find the smallest Charnick-Carmichael number.

  var m: Natural = 0
  var incr = (if n >= 5: 5 else: 1) * Factors[n]  # For n >= 5, a(n) is a multiple of 5.

  while true:
    inc m, incr
    if isChernick(n, m):
      return (m, toSeq(factors(n, m)))

#———————————————————————————————————————————————————————————————————————————————————————————————————

import strformat

for n in 3..Max:
  let (m, factors) = a(n)

  stdout.write fmt"a({n}) = U({n}, {m}) = "
  var s = ""
  for factor in factors:
    s.addSep(" × ")
    s.add($factor)
  stdout.write s, '\n'
