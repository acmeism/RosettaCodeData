import math, strformat

const N = 999

func isPrime(n: Positive): bool =
  if (n and 1) == 0: return n == 2
  if (n mod 3) == 0: return n == 3
  var d = 5
  var delta = 2
  while d <= sqrt(n.toFloat).int:
    if n mod d == 0: return false
    inc d, delta
    delta = 6 - delta
  result = true

echo "index  prime  prime sum"
var s = 0
var idx = 0
for n in 2..N:
  if n.isPrime:
    inc idx
    s += n
    if s.isPrime: echo &"{idx:3}   {n:5}   {s:7}"
