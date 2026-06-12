import strutils

func isPrime(n: Natural): bool =
  if n < 2: return false
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true

var pi = 0
var n = 1
while true:
  stdout.write ($pi).align(2), if n mod 10 == 0: '\n' else: ' '
  inc n
  if n.isPrime:
    inc pi
    if pi == 22: break
echo()
