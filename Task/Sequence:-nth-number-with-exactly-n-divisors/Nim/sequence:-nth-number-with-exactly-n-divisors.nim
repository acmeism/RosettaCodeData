import math, strformat
import bignum

type Record = tuple[num, count: Natural]

template isOdd(n: Natural): bool =
  (n and 1) != 0

func isPrime(n: int): bool =
  let bi = newInt(n)
  result = bi.probablyPrime(25) != 0

proc findPrimes(limit: Natural): seq[int] {.compileTime.} =
  result = @[2]
  var isComposite = newSeq[bool](limit + 1)
  var p = 3
  while true:
    let p2 = p * p
    if p2 > limit: break
    for i in countup(p2, limit, 2 * p):
      isComposite[i] = true
    while true:
      inc p, 2
      if not isComposite[p]: break
  for n in countup(3, limit, 2):
    if not isComposite[n]:
      result.add n

const Primes = findPrimes(22_000)

proc countDivisors(n: Natural): int =
  result = 1
  var n = n
  for i, p in Primes:
    if p * p > n: break
    if n mod p != 0: continue
    n = n div p
    var count = 1
    while n mod p == 0:
      n = n div p
      inc count
    result *= count + 1
    if n == 1: return
  if n != 1: result *= 2

const Max = 45
var records: array[0..Max, Record]
echo &"The first {Max} terms in the sequence are:"

for n in 1..Max:

  if n.isPrime:
    var z = newInt(Primes[n - 1])
    z = pow(z, culong(n - 1))
    echo &"{n:2}: {z}"

  else:
    var count = records[n].count
    if count == n:
      echo &"{n:2}: {records[n].num}"
      continue
    let odd = n.isOdd
    let d = if odd or n == 2 or n == 10: 1 else: 2
    var k = records[n].num
    while true:
      inc k, d
      if odd:
        let sq = sqrt(k.toFloat).int
        if sq * sq != k: continue
      let cd = k.countDivisors()
      if cd == n:
        inc count
        if count == n:
          echo &"{n:2}: {k}"
          break
      elif cd in (n + 1)..Max and records[cd].count < cd and
           k > records[cd].num and (d == 1 or d == 2 and not cd.isOdd):
        records[cd].num = k
        inc records[cd].count
