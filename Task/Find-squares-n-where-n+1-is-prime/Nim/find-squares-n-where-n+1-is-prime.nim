import std/strutils

func isPrime(n: Positive): bool =
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  var d = 3
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, 2
  result = true

var list = @[1]
var n = 2
var n2 = 4
while n2 < 1000:
  if isPrime(n2 + 1):
    list.add n2
  inc n, 2
  n2 = n * n

echo list.join(" ")
