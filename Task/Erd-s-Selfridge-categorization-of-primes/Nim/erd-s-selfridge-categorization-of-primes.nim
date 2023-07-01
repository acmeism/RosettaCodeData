import std/[bitops, math, sequtils, strformat, strutils, tables]

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

const Limit = int(ln(1e6) * 1e6 * 1.2)
let primes = initPrimes(Limit)

func primeFactors(n: Positive): seq[Positive] =
  ## Return the list of prime factors of "n".
  ## Duplicate primes are excluded.
  var n = n
  var last = 0
  while (n and 1) == 0:
    if last != 2:
      result.add 2
      last = 2
    n = n shr 1
  var d = 3
  while d * d <= n:
    while n mod d == 0:
      if last != d:
        result.add d
        last = d
      n = n div d
    inc d, 2
  if n > 1: result.add n

type Category = 1..12
var prevCats: Table[int, int]

proc cat(p: Natural): Category =
  ## Recursive procedure to compute the catagory of "p".
  if p in prevCats: return prevCats[p]
  let pf = primeFactors(p + 1)
  if pf.allIt(it == 2 or it == 3):
    return 1
  for c in 2..11:
    if pf.allIt(cat(it) < c):
      prevCats[p] = c
      return c
  result = 12


var es: array[Category, seq[Positive]]

echo "First 200 primes:\n"
for p in primes[0..199]:
  es[p.cat].add p
for c in 1..6:
  if es[c].len > 0:
    echo &"Category {c}:"
    echo es[c].join(" ")
    echo()

echo "First million primes:\n"
for p in primes[200..999_999]:
  es[p.cat].add p
for c in 1..12:
  let e = es[c]
  if e.len > 0:
    echo &"Category {c:>2}: first = {e[0]:>7}  last = {e[^1]:>8}  count = {e.len:>6}"
