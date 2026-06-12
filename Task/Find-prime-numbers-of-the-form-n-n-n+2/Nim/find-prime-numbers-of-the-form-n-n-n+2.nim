import strutils

func isPrime(n: Positive): bool =
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

for n in 1..<200:
  let p = n * n * n + 2
  if p.isPrime:
    echo ($n).align(3), " → ", p
