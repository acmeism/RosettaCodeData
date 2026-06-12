func isPrime(n: Positive): bool =
  ## Return true if "n" is prime.
  ## Assume n >= 5 and n not multiple of 2 and 3.
  var d = 5
  var step = 2
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, step
    step = 6 - step
  result = true

iterator primes(): tuple[rank, value: int] =
  ## Yield the primes preceded by their rank in the sequence.
  yield (1, 2)
  yield (2, 3)
  var idx = 2
  var n = 5
  var step = 2
  while true:
    if n.isPrime:
      inc idx
      yield (idx, n)
    inc n, step
    step = 6 - step

for (i, n) in primes():
  if i == 10001:
    echo "10001st prime: ", n
    break
