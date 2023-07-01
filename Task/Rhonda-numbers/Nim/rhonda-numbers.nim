import std/[sequtils, strformat, strutils]

type Base = 2..36

template isEven(n: int): bool = (n and 1) == 0

func isPrime(n: Natural): bool =
  ## Return true if "n" is prime.
  if n < 2: return false
  if n.isEven: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
  return true

func digitProduct(n: Positive; base: Base): int =
  ## Return the product of digits of "n" in given base.
  var n = n.Natural
  result = 1
  while n != 0:
    result *= n mod base
    n = n div base

func primeFactorSum(n: Positive): int =
  ## Return the sum of prime factors of "n".
  var n = n.Natural
  while n.isEven:
    inc result, 2
    n  = n shr 1
  var d = 3
  while d * d <= n:
    while n mod d == 0:
      inc result, d
      n = n div d
    inc d, 2
  if n > 1: inc result, n

func isRhondaNumber(n: Positive; base: Base): bool =
  ## Return true if "n" is a Rhonda number to given base.
  n.digitProduct(base) == base * n.primeFactorSum

const Digits = toSeq('0'..'9') & toSeq('a'..'z')

func toBase(n: Positive; base: Base): string =
  ## Return the string representation of "n" in given base.
  var n = n.Natural
  while true:
    result.add Digits[n mod base]
    n = n div base
    if n == 0: break
  # Reverse the digits.
  for i in 1..(result.len shr 1):
    swap result[i - 1], result[^i]


const N = 10

for base in 2..36:
  if base.isPrime: continue
  echo &"First {N} Rhonda numbers to base {base}:"
  var rhondaList: seq[Positive]
  var n = 1
  var count = 0
  while count < N:
    if n.isRhondaNumber(base):
      rhondaList.add n
      inc count
    inc n
  echo "In base 10: ", rhondaList.join(" ")
  echo &"In base {base}: ", rhondaList.mapIt(it.toBase(base)).join(" ")
  echo()
