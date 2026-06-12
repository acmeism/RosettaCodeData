func isPrime(n: Natural): bool =
  ## Return true if "n" is prime.
  ## "n" is expected not to be a multiple of 2 or 3.
  var k = 5
  while k * k <= n:
    if n mod k == 0 or n mod (k + 2) == 0: return false
    inc k, 6
  result = true

var sum = 2 + 3
var n = 5
while n < 2_000_000:
  if n.isPrime:
    inc sum, n
  inc n, 2
  if n.isPrime:
    inc sum, n
  inc n, 4

echo sum
