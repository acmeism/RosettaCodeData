func isOddPrime(n: uint64): bool =
  if n == 1: return false
  if n mod 3 == 0: return n == 3
  var d = 5u
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true

var p = 2u64
for e in 1..63:
  if isOddPrime(p - 1):
    echo "2^", e, " - 1"
  p *= 2
