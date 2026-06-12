import std/[sequtils, strutils]

func isPrime(n: Natural): bool =
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var k = 5
  while k * k <= n:
    if n mod k == 0 or n mod (k + 2) == 0: return false
    inc k, 6
  result = true

func totient(n: Natural): int =
  var n = n
  result = n
  var i = 2
  while i * i <= n:
    if n mod i == 0:
      while n mod i == 0:
        n = n div i
      dec result, result div i
    if i == 2: i = 1
    inc i, 2
  if n > 1:
    dec result, result div n

const Max = 1_000_000
var a: array[Max, int]
var sumPhi = 0
for n in 1..Max:
  inc sumPhi, n.totient
  if n.isPrime:
    a[n - 1] = a[n - 2]
  else:
    a[n-1] = n * (n - 1) shr 1 + 1 - sumPhi

echo "Number of pairs with common factors - First one hundred terms:"
for n in countup(0, 99, 10):
  echo a[n..n+9].mapIt(align($it, 4)).join(" ")
echo()
var limit = 1
while limit <= Max:
  echo "The $1th term: $2".format(insertSep($limit), insertSep($a[limit-1]))
  limit *= 10
