import strutils, sugar

func isPrime(n: Positive): bool =
  if n == 1: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    if n mod (d + 2) == 0: return false
    inc d, 6
  result = true

# List of primes.
const Primes = collect(newSeq, for n in 2..<100: (if n.isPrime: n))

var concatPrimes: set[0..9999]    # Using a set to eliminate duplicates and avoid sort.
for p1 in Primes:
  for p2 in Primes:
    let n = p2 + p1 * (if p2 < 10: 10 else: 100)
    if n.isPrime:
      concatPrimes.incl n

echo "Found $# primes which are a concatenation of two primes below 100:".format(concatPrimes.len)
var i = 1
for n in concatPrimes:
  stdout.write ($n).align(4), if i mod 16 == 0: '\n' else: ' '
  inc i
