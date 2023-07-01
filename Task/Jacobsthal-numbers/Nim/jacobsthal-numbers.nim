import std/strutils

func isPrime(n: Natural): bool =
  ## Return true if "n" is prime.
  if n < 2: return false
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var step = 2
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, step
    step = 6 - step
  result = true

iterator jacobsthalSequence(first, second: int): int =
  ## Yield the successive Jacobsthal numbers or
  ## Jacobsthal-Lucas numbers.
  var prev = first
  var curr = second
  yield prev
  yield curr
  while true:
    swap prev, curr
    curr += curr + prev
    yield curr

iterator jacobsthalOblong(): int =
  ## Yield the successive Jacobsthal oblong numbers.
  var prev = -1
  for n in jacobsthalSequence(0, 1):
    if prev >= 0:
      yield prev * n
    prev = n

iterator jacobsthalPrimes(): int =
  ## Yield the successive Jacobsthal prime numbers.
  for n in jacobsthalSequence(0, 1):
    if n.isPrime:
      yield n


echo "First 30 Jacobsthal numbers:"
var count = 0
for n in jacobsthalSequence(0, 1):
  inc count
  stdout.write align($n, 11)
  if count mod 6 == 0: echo()
  if count == 30: break

echo "\nFirst 30 Jacobsthal-Lucas numbers:"
count = 0
for n in jacobsthalSequence(2, 1):
  inc count
  stdout.write align($n, 11)
  if count mod 6 == 0: echo()
  if count == 30: break

echo "\nFirst 20 Jacobsthal oblong numbers:"
count = 0
for n in jacobsthalOblong():
  inc count
  stdout.write align($n, 13)
  if count mod 5 == 0: echo()
  if count == 20: break

echo "\nFirst 10 Jacobsthal prime numbers:"
count = 0
for n in jacobsthalPrimes():
  inc count
  stdout.write align($n, 11)
  if count mod 5 == 0: echo()
  if count == 10: break
