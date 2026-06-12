import sequtils, strutils

func isPrime(n: Positive): bool =
  if n == 1: return false
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, 2
    if n mod d == 0:
      return false
    inc d, 4
  result = true

func hasLastDigitOdd(n: Natural): bool =
  var n = n
  n = n div 10
  while n != 0:
    if (n mod 10 and 1) != 0: return false
    n = n div 10
  result = true

iterator primesOneOdd(lim: Positive): int =
  var n = 1
  while n <= lim:
    if n.hasLastDigitOdd and n.isPrime:
      yield n
    inc n, 2


let list = toSeq(primesOneOdd(1000))
echo "Found $# primes with only one odd digit below 1000:".format(list.len)
for i, n in list:
  stdout.write ($n).align(3), if (i + 1) mod 9 == 0: '\n' else: ' '

var count = 0
for _ in primesOneOdd(1_000_000):
  inc count
echo "\nFound $# primes with only one odd digit below 1_000_000.".format(count)
