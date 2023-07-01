import math, strutils

func isPrime(n: int): bool =
  ## Check if "n" is prime by trying successive divisions.
  ## "n" is supposed not to be a multiple of 2 or 3.
  var d = 5
  var delta = 2
  while d <= int(sqrt(n.toFloat)):
    if n mod d == 0: return false
    inc d, delta
    delta = 6 - delta
  result = true

func isProduct23(n: int): bool =
  ## Check if "n" has only 2 and 3 for prime divisors
  ## (i.e. that "n = 2^u * 3^v").
  var n = n
  while (n and 1) == 0: n = n shr 1
  while n mod 3 == 0: n = n div 3
  result = n == 1

iterator pierpont(maxCount: Positive; k: int): int =
  ## Yield the Pierpoint primes of first or second kind according
  ## to the value of "k" (+1 for first kind, -1 for second kind).
  yield 2
  yield 3
  var n = 5
  var delta = 2   # 2 and 4 alternatively to skip the multiples of 2 and 3.
  yield n
  var count = 3
  while count < maxCount:
    inc n, delta
    delta = 6 - delta
    if isProduct23(n - k) and isPrime(n):
      inc count
      yield n

template pierpont1*(maxCount: Positive): int = pierpont(maxCount, +1)
template pierpont2*(maxCount: Positive): int = pierpont(maxCount, -1)


when isMainModule:

  echo "First 50 Pierpont primes of the first kind:"
  var count = 0
  for n in pierpont1(50):
    stdout.write ($n).align(9)
    inc count
    if count mod 10 == 0: stdout.write '\n'

  echo ""
  echo "First 50 Pierpont primes of the second kind:"
  count = 0
  for n in pierpont2(50):
    stdout.write ($n).align(9)
    inc count
    if count mod 10 == 0: stdout.write '\n'
