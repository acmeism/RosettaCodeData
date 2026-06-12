import sequtils, strutils

const N = 10_000

func isPrime(n: Positive): bool =
  if (n and 1) == 0: return n == 2
  var m = 3
  while m * m <= n:
    if n mod m == 0: return false
    inc m, 2
  result = true

var primeList: seq[0..N]
var primeSet: set[0..N]

for n in 2..N:
  if n.isPrime:
    primeList.add n
    primeSet.incl n

type Digit = 0..9

proc digits(n: Positive): seq[Digit] =
  var n = n.int
  while n != 0:
    result.add n mod 10
    n = n div 10

proc isExtraPrime(prime: Positive): bool =
  var sum = 0
  for digit in prime.digits:
    if digit notin primeSet: return false
    inc sum, digit
  result = sum in primeSet

let result = primeList.filterIt(it.isExtraPrime)
echo "Found $1 extra primes less than $2:".format(result.len, N)
for i, p in result:
  stdout.write ($p).align(4)
  stdout.write if (i + 1) mod 9 == 0: '\n' else: ' '
