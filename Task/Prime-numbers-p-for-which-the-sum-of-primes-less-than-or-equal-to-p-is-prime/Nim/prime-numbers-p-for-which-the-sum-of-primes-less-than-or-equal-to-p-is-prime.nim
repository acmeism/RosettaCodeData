import strutils, sugar

const
  N = 1000 - 1            # Maximum value for prime.
  S = N * (N + 1) div 2   # Maximum value for sum.

var composite: array[2..S, bool]
for n in 2..S:
  let n2 = n * n
  if n2 > S: break
  if not composite[n]:
    for k in countup(n2, S, n):
      composite[k] = true

template isPrime(n: int): bool = not composite[n]

let primes = collect:
                 for n in 2..N:
                   if n.isPrime: n

var list: seq[int]
var sum = 0
for p in primes:
  sum += p
  if sum.isPrime:
    list.add p

echo "Found $# primes:".format(list.len)
echo list.join(" ")
