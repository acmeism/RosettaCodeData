import sequtils, strutils

const N = 1_000_000 - 1   # Sieve of Erathostenes size.

# Sieve of Erathostenes.
var composite: array[2..N, bool]

for n in countup(3, N, 2):  # We ignore the even values.
  let n2 = n * n
  if n2 > N: break
  if not composite[n]:
    for k in countup(n2, N, 2 * n):
      composite[k] = true

template isPrime(n: Positive): bool = not composite[n]


iterator primes123(lim: Positive): int =
  var n = 1001    # First odd value with four digits.
  while n <= lim:
    if n.isPrime and ($n).find("123") >= 0:
      yield n
    inc n, 2


let list = toSeq(primes123(100_000 - 1))
echo "Found ", list.len, " “123” primes less than 100_000:"
for i, n in list:
  stdout.write ($n).align(5), if (i + 1) mod 8 == 0: '\n' else: ' '
echo '\n'

var count = 0
for _ in primes123(1_000_000): inc count
echo "Found ", count, " “123” primes less than 1_000_000."
