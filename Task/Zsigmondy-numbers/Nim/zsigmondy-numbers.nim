import std/[algorithm, math, strformat]

func isPrime(n: Natural): bool =
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

func divisors(n: Positive): seq[int] =
  for d in 1..sqrt(n.toFloat).int:
    if n mod d == 0:
      result.add d
      if n div d != d:
        result.add n div d
  result.sort()

func zs(n, a, b: Positive): int =
  let dn = a^n - b^n
  if dn.isPrime: return dn
  var divs = dn.divisors
  for m in 1..<n:
    let dm = a^m - b^m
    for i in countdown(divs.high, 1):
      if gcd(dm, divs[i]) != 1:
        divs.delete i
  result = divs[^1]

const N = 15
for (a, b) in [(2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1), (3, 2), (5, 3), (7, 3), (7, 5)]:
  echo &"Zsigmondy(n, {a}, {b}) – First {N} terms:"
  for n in 1..N:
    stdout.write zs(n, a, b), ' '
  echo '\n'
