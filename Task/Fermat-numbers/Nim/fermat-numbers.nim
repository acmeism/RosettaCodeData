import math
import bignum
import strformat
import strutils
import tables
import times

const Composite = {9: "5529", 10: "6078", 11: "1037", 12: "5488", 13: "2884"}.toTable

const Subscripts = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]

let One = newInt(1)

#---------------------------------------------------------------------------------------------------

func fermat(n: int): Int {.inline.} = 2^(culong(2^n)) + 1

#---------------------------------------------------------------------------------------------------

template isProbablyPrime(n: Int): bool = n.probablyPrime(25) != 0

#---------------------------------------------------------------------------------------------------

func pollardRhoG(x, n: Int): Int {.inline.} = (x * x + 1) mod n

#---------------------------------------------------------------------------------------------------

proc pollardRhoFast(n: Int): Int =

  let start = getTime()
  var
    x = newInt(2)
    y = newInt(2)
    count = 0
    z = One

  while true:
    x = pollardRhoG(x, n)
    y = pollardRhoG(pollardRhoG(y, n), n)
    result = abs(x - y)
    z = z * result mod n
    inc count
    if count == 100:
      result = gcd(z, n)
      if result != One: break
      z = One
      count = 0

  let duration = (getTime() - start).inMilliseconds
  echo fmt"    Pollard rho try factor {n} elapsed time = {duration} ms (factor = {result})."
  if result == n:
    result = newInt(0)

#---------------------------------------------------------------------------------------------------

proc factors(fermatIndex: int; n: Int): seq[Int] =

  var n = n
  var factor: Int
  while true:

    if n.isProbablyPrime():
      result.add(n)
      break

    if fermatIndex in Composite:
      let stop = Composite[fermatIndex]
      let s = $n
      if s.startsWith(stop):
        result.add(newInt(-s.len))
        break

    factor = pollardRhoFast(n)
    if factor.isZero():
      result.add(n)
      break
    result.add(factor)
    n = n div factor

#---------------------------------------------------------------------------------------------------

func `$`(factors: seq[Int]): string =

  if factors.len == 1:
    result = fmt"{factors[0]} (PRIME)"

  else:
    result = $factors[0]
    let start = result.high
    for factor in factors[1..^1]:
      result.addSep(" * ", start)
      result.add(if factor < 0: fmt"(C{-factor})" else: $factor)

#---------------------------------------------------------------------------------------------------

func subscript(n: Natural): string =
  var n = n
  while true:
    result.insert(Subscripts[n mod 10], 0)
    n = n div 10
    if n == 0: break

#———————————————————————————————————————————————————————————————————————————————————————————————————

echo "First 10 Fermat numbers:"
for i in 0..9:
  echo fmt"F{subscript(i)} = {fermat(i)}"

echo ""
echo "First 12 Fermat numbers factored:"
for i in 0..12:
  echo fmt"F{subscript(i)} = {factors(i, fermat(i))}"
