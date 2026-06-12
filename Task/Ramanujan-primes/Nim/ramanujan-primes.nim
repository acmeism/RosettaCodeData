import math, sequtils, strutils, times

let t0 = now()

type PrimeCounter = seq[int]

proc initPrimeCounter(limit: Positive): PrimeCounter =
  doAssert limit > 1
  result = repeat(1, limit)
  result[0] = 0
  result[1] = 0
  for i in countup(4, limit - 1, 2): result[i] = 0
  var p = 3
  var p2 = 9
  while p2 < limit:
    if result[p] != 0:
      for q in countup(p2, limit - 1, p shl 1):
        result[q] = 0
    p2 += (p + 1) shl 2
    if p2 >= limit: break
    inc p, 2
  # Compute partial sums in place.
  var sum = 0
  for item in result.mitems:
    sum += item
    item = sum

func ramanujanMax(n: int): int {.inline.} = int(ceil(4 * n.toFloat * ln(4 * n.toFloat)))

proc ramanujanPrime(pi: PrimeCounter; n: int): int =
  if n == 1: return 2
  var max = ramanujanMax(n)
  if (max and 1) == 1: dec max
  for i in countdown(max, 2, 2):
    if pi[i] - pi[i div 2] < n:
      return i + 1

let pi = initPrimeCounter(1 + ramanujanMax(100_000))

for n in 1..100:
  stdout.write ($ramanujanPrime(pi, n)).align(4), if n mod 20 == 0: '\n' else: ' '

echo "\nThe 1000th Ramanujan prime is ", ramanujanPrime(pi, 1_000)
echo "The 10_000th Ramanujan prime is ", ramanujanPrime(pi, 10_000)
echo "The 100_000th Ramanujan prime is ", ramanujanPrime(pi, 100_000)

echo "\nElapsed time: ", (now() - t0).inMilliseconds, " ms"
