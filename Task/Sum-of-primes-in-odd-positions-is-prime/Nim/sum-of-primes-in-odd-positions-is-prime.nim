import strformat

template isOdd(n: Natural): bool = (n and 1) != 0
template isEven(n: Natural): bool = (n and 1) == 0

func isPrime(n: Positive): bool =
  if n == 1: return false
  if n.isEven: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true

# Compute the sums of primes at odd position.
echo "  i  p(i)   sum"
var idx = 0
var sum = 0
var p = 1
while p < 1000:
  inc p
  if p.isPrime:
    inc idx
    if idx.isOdd:
      inc sum, p
      if sum.isPrime:
        echo &"{idx:3}  {p:3}  {sum:5}"
