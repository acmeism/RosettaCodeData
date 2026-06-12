import std/[algorithm, bitops, math, strformat, strutils, tables]

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

proc digits(n: Positive): seq[0..9] =
  var n = n.Natural
  while n != 0:
    result.add n mod 10
    n = n div 10

const Limit = 1_000_000_000
const MaxIndex = log10(Limit.toFloat).int
let primes = initPrimes(Limit)

var anaPrimes: Table[int, seq[int]]
for p in primes:
  var key = 1
  for digit in p.digits:
    key *= primes[digit]
  anaPrimes.mgetOrPut(key, @[]).add p

var largest: array[1..MaxIndex, int]
var groups: array[1..MaxIndex, seq[seq[int]]]
for key, values in anaPrimes.pairs:
  let nd = values[0].digits.len
  if values.len > largest[nd]:
    largest[nd] = values.len
    groups[nd] = @[values]
  elif values.len == largest[nd]:
    groups[nd].add values

var j = 1000
for i in 3..MaxIndex:
  echo &"Largest group(s) of anaprimes before {insertSep($j)}: {largest[i]} members:"
  groups[i].sort(proc (x, y: seq[int]): int = cmp(x[0], y[0]))
  for g in groups[i]:
    echo &"  First: {insertSep($g[0])}  Last: {insertSep($g[^1])}"
  j *= 10
  echo()
