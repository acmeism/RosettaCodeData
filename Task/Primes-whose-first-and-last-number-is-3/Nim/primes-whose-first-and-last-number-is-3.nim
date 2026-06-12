import strformat

func isPrime(n: Positive): bool =
  for d in countup(3, n, 2):
    if d * d > n: break
    if n mod d == 0: return false
  result = true


iterator primes3x3(lim: Natural): int =
  assert lim >= 3
  yield 3
  var m = 100
  while m * 3 < lim:
    for n in countup(3 * m + 3, 4 * m - 7, 10):
      if n > lim: break
      if n.isPrime: yield n
    m *= 10

var list: seq[int]
var count = 0
for n in primes3x3(1_000_000):
  inc count
  if n < 4000: list.add n

echo &"Found {list.len} primes starting and ending with 3 below 4_000:"
for i, n in list:
  stdout.write &"{n:4}", if (i + 1) mod 11 == 0: '\n' else: ' '

echo &"\nFound {count} primes starting and ending with 3 below 1_000_000."
