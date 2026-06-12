import std/[bitops, math]

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
  ## Initialize the list of primes from 2 to "lim".
  var composite = newSieve(lim)
  composite[1] = true
  for n in countup(3, sqrt(lim.toFloat).int, 2):
    if not composite[n]:
      for k in countup(n * n, lim, 2 * n):
        composite[k] = true
  result.add 2
  for n in countup(3, lim, 2):
    if not composite[n]:
      result.add n

let primes = initPrimes(1_000_000)

var prev = 0
var largestDiff = 0
for n in primes:
  largestDiff = max(largestDiff, n - prev)
  prev = n
echo "Largest difference: ", largestDiff
