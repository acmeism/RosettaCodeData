import std/rationals

func isPrime(n: Natural): bool =
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var k = 5
  while k * k <= n:
    if n mod k == 0 or n mod (k + 2) == 0: return false
    inc k, 6
  result = true

iterator wolstenholme(): (int, int) =
  var count = 0
  var k = 1
  var s = 1.toRational
  while true:
    inc count
    yield (count, s.num)
    inc k
    s += 1 // (k * k)

echo "First 20 Wolstenholme numbers:"
var wprimes: seq[int]
for (count, n) in wolstenholme():
  echo n
  if n.isPrime:
    wprimes.add n
  if count == 20: break

echo "\nFirst 4 Wolstenholme primes:"
for i in 0..3:
  echo wprimes[i]
