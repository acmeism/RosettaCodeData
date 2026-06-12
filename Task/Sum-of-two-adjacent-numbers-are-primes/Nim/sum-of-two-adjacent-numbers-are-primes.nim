import std/[bitops, math, strformat, strutils]

type Sieve = object
  data: seq[byte]

func `[]`(sieve: Sieve; idx: Positive): bool =
  ## Return value of element at index "idx".
  let idx = idx shr 1
  let iByte = idx shr 3
  let iBit = idx and 7
  result = sieve.data[iByte].testBit(iBit)

func `[]=`(sieve: var Sieve; idx: Positive; val: bool) =
  ## Set value of element at index "idx".
  let idx = idx shr 1
  let iByte = idx shr 3
  let iBit = idx and 7
  if val: sieve.data[iByte].setBit(iBit)
  else: sieve.data[iByte].clearBit(iBit)

func newSieve(lim: Positive): Sieve =
  ## Create a sieve with given maximal index.
  result.data = newSeq[byte]((lim + 16) shr 4)

func initPrimes(lim: Positive): seq[Natural] =
  ## Initialize the list of primes from 3 to "lim".
  var composite = newSieve(lim)
  composite[1] = true
  for n in countup(3, sqrt(lim.toFloat).int, 2):
    if not composite[n]:
      for k in countup(n * n, lim, 2 * n):
        composite[k] = true
  for n in countup(3, lim, 2):
    if not composite[n]:
      result.add n

let primes = initPrimes(200_000_000)

echo "The first 20 pairs of natural numbers whose sum is prime are:"
var count = 0
for p in primes:
  inc count
  if count <= 20:
    echo &"{(p-1) div 2} + {(p+1) div 2} = {p}"
    if count == 20: echo()
  elif count == 10_000_000:
    echo "The 10 millionth such pair is:"
    echo &"{(p-1) div 2} + {(p+1) div 2} = {p}"
    break
