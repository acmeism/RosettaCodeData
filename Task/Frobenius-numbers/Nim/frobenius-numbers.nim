import sequtils, strutils

func isOddPrime(n: Positive): bool =
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true

iterator oddPrimes(): int =
  yield 3
  var n = 5
  while true:
    if n.isOddPrime: yield n
    inc n, 2
    if n.isOddPrime: yield n
    inc n, 4

iterator frobenius(lim: Positive): int =
  var p1 = 2
  for p2 in oddPrimes():
    let f = p1 * p2 - p1 - p2
    if f < lim: yield f
    else: break
    p1 = p2

const N = 10_000
var result = toSeq(frobenius(10_000))
echo "Found $1 Frobenius numbers less than $2:".format(result.len, N)
echo result.join(" ")
