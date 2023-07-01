import std/[algorithm, bitops, math, strformat, strutils, sugar]

### Sieve of Erathostenes.

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

func initPrimes(lim: int32): seq[int32] =
  ## Initialize the list of primes from 3 to "lim".
  var composite = newSieve(lim)
  composite[1] = true
  for n in countup(3, sqrt(lim.toFloat).int, 2):
    if not composite[n]:
      for k in countup(n * n, lim, 2 * n):
        composite[k] = true
  for n in countup(3i32, lim, 2):
    if not composite[n]:
      result.add n


### Task functions.

func isTetraPrime(n: int32): bool =
  ## Return true if "n" is a tetraprime.
  var n = n
  if n < 2: return
  const Inc = [4, 2, 4, 2, 4, 6, 2, 6]    # Wheel.
  var count = 0

  if (n and 1) == 0:
    inc count
    n = n shr 1
    if (n and 1) == 0: return
  if n mod 3 == 0:
    inc count
    n = n div 3
    if n mod 3 == 0: return
  if n mod 5 == 0:
    inc count
    n = n div 5
    if n mod 5 == 0: return
  var k = 7i32
  var i = 0
  while k * k <= n:
    if n mod k == 0:
      inc count
      n = n div k
      if count > 4 or n mod k == 0: return
    inc k, Inc[i]
    i = (i + 1) and 7
  if n > 1: inc count
  result = count == 4

func median(a: openArray[int32]): int32 =
  ## Return the median value of "a".
  let m = a.len div 2
  result = if (a.len and 1) == 0: (a[m] + a[m-1]) div 2 else: a[m]


type Position {.pure.} = enum Preceding = "preceding", Following = "following"

proc printResult(list: seq[int32]; count: int; lim: int; pos: Position; display: bool) =
  ## Print the result for the given list and the given count.
  let c = if display: ':' else: '.'
  let lim = insertSep($lim)
  echo &"Found {list.len} primes under {lim} whose {pos} neighboring pair are tetraprimes{c}"
  if display:
    for i, p in list:
      stdout.write &"{p:5}"
      stdout.write if i mod 10 == 9 or i == list.high: '\n' else: ' '
    echo()
  echo &"  Of which {count} have a neighboring pair one of whose factors is 7.\n"
  var gaps = collect(for i in 1..list.high: list[i] - list[i - 1])
  gaps.sort()
  echo &"  Minimum gap between those {list.len} primes: {gaps[0]}"
  echo &"  Median  gap between those {list.len} primes: {gaps.median}"
  echo &"  Maximum gap between those {list.len} primes: {gaps[^1]}"
  echo()


const Steps = [int32 100_000, 1_000_000, 10_000_000]

var list1: seq[int32]  # Prime whose preceding neighboring pair are tetraprimes.
var list2: seq[int32]  # Prime whose following neighboring pair are tetraprimes.
var count1 = 0         # Number of primes from "list1" with one value of the pairs multiple of 7.
var count2 = 0         # Number of primes from "list2" with one value of the pairs multiple of 7.

let primes = initPrimes(Steps[^1])

var limit = Steps[0]
var iLimit = 0
var display = true      # True to display the primes.
var last = primes[^1]

for p in primes:

  if p >= limit or p == last:
    printResult(list1, count1, limit, Preceding, display)
    printResult(list2, count2, limit, Following, display)
    if iLimit == Steps.high: break
    inc iLimit
    limit = Steps[iLimit]
    display = false   # Don't display next primes.

  if isTetraPrime(p - 2) and isTetraPrime(p - 1):
    list1.add p
    if (p - 2) mod 7 in [0, 6]:
      inc count1

  if isTetraPrime(p + 1) and isTetraPrime(p + 2):
    list2.add p
    if (p + 1) mod 7 in [0, 6]:
      inc count2
