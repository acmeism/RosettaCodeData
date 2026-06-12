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

let primes = initPrimes(5_000_000)

func digitalSum(n: Natural): int =
  ## Return the digital sum of "n".
  var n = n
  while n != 0:
    result += n mod 10
    n = n div 10

iterator honakerPrimes(primes: seq[Natural]): tuple[pos, val: int] =
  ## Yield the position and value of Honaker primes from the given list of primes.
  for i, n in primes:
    if digitalSum(i + 1) == digitalSum(n):
      yield (i + 1, n)

echo "List of positions and values of first 50 Honeker primes:"
var count = 0
for (pos, val) in honakerPrimes(primes):
  inc count
  if count <= 50:
    stdout.write &"({pos:>3}, {val:>4})"
    stdout.write if count mod 5 == 0: '\n' else: ' '
  elif count == 10_000:
    echo &"\nThe 10_000th Honeker prime number is {insertSep($val)} at position {insertSep($pos)}."
    break
