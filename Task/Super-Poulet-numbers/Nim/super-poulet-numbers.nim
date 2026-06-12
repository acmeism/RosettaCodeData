import std/[strformat, strutils]

proc powMod*(a, n, m: int): int =
  ## Return "a^n mod m".
  var a = a mod m
  var n = n
  if a > 0:
    result = 1
    while n > 0:
      if (n and 1) != 0:
        result = (result * a) mod m
      n = n shr 1
      a = (a * a) mod m

func isPrime(n: Natural): bool =
  ## Return true if "n" is prime.
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var k = 5
  var delta = 2
  while k * k <= n:
    if n mod k == 0: return false
    inc k, delta
    delta = 6 - delta
  result = true

iterator divisors(n: Positive): int =
  ## Yield the divisors of "n", except 1.
  yield n
  var d = 2
  while d * d <= n:
    if n mod d == 0:
      let q = n div d
      yield d
      if q != d:
        yield q
    inc d

func isSuperPouletNumber(n: int): bool =
  ## Return true is "x" is a Fermat pseudoprime to base "a".
  if n.isPrime or powMod(2, n - 1, n) != 1: return false
  for d in n.divisors:
    if powMod(2, d, d) != 2:
      return false
  result = true

var n = 2
var count = 0
while true:
  if n.isSuperPouletNumber:
    inc count
    if count <= 20:
      stdout.write &"{n:5}"
      stdout.write if count mod 5 == 0: '\n' else: ' '
      if count == 20: echo()
    elif n > 1_000_000:
      echo &"First super-Poulet number greater than one million is {insertSep($n)} at index {count}."
      break
  inc n
