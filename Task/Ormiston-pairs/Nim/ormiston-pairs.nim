import std/[algorithm, bitops, math, strformat, strutils]

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

let primes = initPrimes(100_000_000)

func digits(n: Positive): seq[int] =
  ## Return the sorted list of digits of "n".
  var n = n.Natural
  while n != 0:
    result.add n mod 10
    n = n div 10
  result.sort()

echo "First 30 Ormiston pairs:"
var count = 0
var limit = 100_000
for i in 1..(primes.len - 2):
  let p1 = primes[i]
  let p2 = primes[i + 1]
  if p1.digits == p2.digits:
    inc count
    if count <= 30:
      stdout.write &"({p1:5}, {p2:5})"
      stdout.write if count mod 3 == 0: '\n' else: ' '
      if count == 30: echo()
    elif p1 >= limit:
      echo &"Number of Ormiston pairs below {insertSep($limit)}: {count - 1}"
      limit *= 10
      if limit == 100_000_000:
        break
