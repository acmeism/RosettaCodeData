func isPrime(n: Natural): bool =
  ## Return "true" is "n" is prime.
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  var step = 2
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, step
    step = 6 - step
  return true

iterator fib(): int =
  var prev = 0
  var curr = 1
  while true:
    yield curr
    swap prev, curr
    inc curr, prev

echo "The first 9 prime Fibonacci numbers are:"
var count = 0
for n in fib():
  if n.isPrime:
    stdout.write n, ' '
    inc count
    if count == 9:
      echo()
      break
