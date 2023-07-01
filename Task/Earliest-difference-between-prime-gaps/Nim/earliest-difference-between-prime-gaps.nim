import std/[bitops, math, strformat, tables]

type Sieve = object
  data: seq[byte]

proc `[]`(sieve: Sieve; idx: Positive): bool =
  let idx = idx shr 1
  let iByte = idx shr 3
  let iBit = idx and 7
  result = sieve.data[iByte].testBit(iBit)

proc `[]=`(sieve: var Sieve; idx: Positive; val: bool) =
  let idx = idx shr 1
  let iByte = idx shr 3
  let iBit = idx and 7
  if val: sieve.data[iByte].setBit(iBit)
  else: sieve.data[iByte].clearBit(iBit)

proc newSieve(lim: Positive): Sieve =
  result.data = newSeq[byte]((lim + 16) shr 4)

proc initPrimes(lim: Positive): seq[Natural] =
  var composite = newSieve(lim)
  composite[1] = true
  for n in countup(3, sqrt(lim.toFloat).int, 2):
    if not composite[n]:
      for k in countup(n * n, lim, 2 * n):
        composite[k] = true
  for n in countup(3, lim, 2):
    if not composite[n]:
      result.add n

const Limit = 100_000_000
let primes = initPrimes(Limit * 5)
var gapStarts: Table[int, int]
for i in 1..primes.high:
  let gap = primes[i] - primes[i - 1]
  if gap notin gapStarts:
    gapStarts[gap] = primes[i - 1]
var pm = 10
var gap1 = 2
while true:
  while gap1 notin gapStarts:
    inc gap1, 2
  let start1 = gapStarts[gap1]
  let gap2 = gap1 + 2
  if gap2 notin gapStarts:
    gap1 = gap2 + 2
    continue
  let start2 = gapStarts[gap2]
  let diff = abs(start2 - start1)
  if diff > pm:
    echo &"Earliest difference > {pm} between adjacent prime gap starting primes:"
    echo &"Gap {gap1} starts at {start1}, gap {gap2} starts at {start2}, difference is {diff}.\n"
    if pm == Limit: break
    pm *= 10
  else:
    gap1 = gap2
