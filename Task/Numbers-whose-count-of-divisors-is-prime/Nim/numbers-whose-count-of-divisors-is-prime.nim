import math, sequtils, strformat, strutils


func divCount(n: Positive): int =
  var n = n
  for d in 1..n:
    if d * d > n: break
    if n mod d == 0:
      inc result
      if n div d != d:
        inc result


func isOddPrime(n: Positive): bool =
  if n < 3 or n mod 2 == 0: return false
  if n mod 3 == 0: return n == 3
  var d = 5
  while d <= sqrt(n.toFloat).int:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true


iterator numWithOddPrimeDivisorCount(lim: Positive): int =
  for k in 1..sqrt(lim.toFloat).int:
    let n = k * k
    if n.divCount().isOddPrime():
      yield n


var list = toSeq(numWithOddPrimeDivisorCount(1000))

echo &"Found {list.len} numbers between 1 and 999 whose number of divisors is an odd prime:"
echo list.join(" ")
echo()

list = toSeq(numWithOddPrimeDivisorCount(100_000))
echo &"Found {list.len} numbers between 1 and 99_999 whose number of divisors is an odd prime:"
for i, n in list:
  stdout.write &"{n:5}", if (i + 1) mod 10 == 0: '\n' else: ' '
echo()
