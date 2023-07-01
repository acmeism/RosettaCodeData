from math import binom
import strutils

# Table of unicode superscript characters.
const Exponents: array[0..9, string] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]

iterator coeffs(n: int): int =
  ## Yield the coefficients of the expansion of (x - 1)ⁿ.
  var sign = 1
  for k in 0..n:
    yield binom(n, k) * sign
    sign = -sign

iterator polyExpansion(n: int): tuple[c, e: int] =
  ## Yield the coefficients and the exponents of the expansion of (x - 1)ⁿ.
  var e = n
  for c in coeffs(n):
    yield(c, e)
    dec e

proc termString(c, e: int): string =
  ## Return the string for the term c * e^n.
  if e == 0:
    result.addInt(c)
  else:
    if c != 1:
      result.addInt(c)
    result.add('x')
    if e != 1:
      result.add(Exponents[e])

proc polyString(n: int): string =
  ## Return the string for the expansion of (x - 1)ⁿ.
  for (c, e) in polyExpansion(n):
    if c < 0:
      result.add(" - ")
    elif e != n:
      result.add(" + ")
    result.add(termString(abs(c), e))

proc isPrime(n: int): bool =
  ## Check if a number is prime using the polynome expansion.
  result = true
  for (c, e) in polyExpansion(n):
    if e in 1..(n-1):   # xⁿ and 1 are eliminated by the subtraction.
      if c mod n != 0:
        return false

#---------------------------------------------------------------------------------------------------

echo "Polynome expansions:"
for p in 0..9:
  echo "(x - 1)$1 = $2".format(Exponents[p], polyString(p))

var primes: string
for p in 2..34:
  if p.isPrime():
    primes.addSep(", ", 0)
    primes.addInt(p)
echo "\nPrimes under 35: ", primes

for p in 35..50:
  if p.isPrime():
    primes.add(", ")
    primes.addInt(p)
echo "\nPrimes under 50: ", primes
