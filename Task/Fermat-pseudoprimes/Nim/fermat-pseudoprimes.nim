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

func isFermatPseudoprime(x, a: int): bool =
  ## Return true is "x" is a Fermat pseudoprime to base "a".
  if x.isPrime: return false
  result = powMod(a, x - 1, x) == 1

const Lim = 50_000

for a in 1..20:
  var count = 0
  var first20: seq[int]
  for x in 1..Lim:
    if x.isFermatPseudoprime(a):
      inc count
      if count <= 20:
        first20.add x
  echo &"Base {a}:"
  echo &"  Number of Fermat pseudoprimes up to {insertSep($Lim)}: {count}"
  echo &"  First 20: {first20.join(\" \")}"
