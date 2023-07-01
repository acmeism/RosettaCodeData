import std/[math, strformat, strutils]

const N = 1_000_000

### Build list of primes.

func isPrime(n: Natural): bool =
  ## Return true if "n" is prime.
  ## "n" should not be a mutiple of 2 or 3.
  var k = 5
  var delta = 2
  while k * k <= n:
    if n mod k == 0: return false
    inc k, delta
    delta = 6 - delta
  result = true

var primes = @[2, 3]
var n = 5
var step = 2
while n <= N:
  if n.isPrime:
    primes.add n
  inc n, step
  step = 6 - step


### Build list of distinct prime factors to
### compute radical and distinct factor count.

var primeFactors: array[1..N, seq[int]]
for p in primes:
  for n in countup(p, N, p):
    primeFactors[n].add p

template radical(n: int): int = prod(primeFactors[n])

template factorCount(n: int): int = primeFactors[n].len


### Task ###

echo "Radical of first 50 positive integers:"
for n in 1..50:
  stdout.write &"{radical(n):2}"
  stdout.write if n mod 10 == 0: '\n' else: ' '
echo()

for n in [99_999, 499_999, 999_999]:
  echo &"Radical for {insertSep($n):>7}: {insertSep($radical(n)):>7}"
echo()

echo "Distribution of the first one million positive"
echo "integers by numbers of distinct prime factors:"
var counts: array[0..7, int]
for n in 1..1_000_000:
  inc counts[factorCount(n)]
for n, count in counts:
  echo &"{n}: {insertSep($count):>7}"
echo()


### Bonus ###

echo "Number of primes and powers of primes"
echo "less than or equal to one million:"
var count = 0
const LogN = ln(N.toFloat)
for p in primes:
  inc count, int(LogN / ln(p.toFloat))
echo insertSep($count)
