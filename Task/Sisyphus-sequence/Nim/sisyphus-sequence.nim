import std/[bitops, math, strformat, strutils, tables]

# Sieve which uses only one bit for odd integers.
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

func initSieve(lim: Positive): Sieve =
  ## Initialize a sieve from 2 to "lim".
  result.data = newSeq[byte]((lim + 16) shr 4)
  result[1] = true
  for n in countup(3, sqrt(lim.toFloat).int, 2):
    if not result[n]:
      for k in countup(n * n, lim, 2 * n):
        result[k] = true

func isPrime(sieve: Sieve; n: int): bool =
  ## Return true if "n" is prime.
  result = if (n and 1) == 0: n == 2 else: not sieve[n]

let sieve = initSieve(700_000_000)

func nextPrime(sieve: Sieve; n: int): int =
  ## Return next prime greater than "n".
  result = n
  while true:
    inc result
    if sieve.isPrime(result):
      return

var p = 0                     # Current prime (none for now).
var count = 0                 # Count of elements in sequence.
var n = 1                     # Last element of sequence.
var counts: CountTable[int]   # Count of occurrences for value < 250.
echo "First 100 terms of the Sisyphus sequence:"

while count < 100_000_000:

  # Process current number.
  inc count
  if count <= 100:
    stdout.write &"{n:3}"
    stdout.write if count mod 10 == 0: '\n' else: ' '
    if count == 100: echo()
  elif count in [1_000, 10_000, 100_000, 1_000_000, 10_000_000, 100_000_000]:
    echo &"The {insertSep($count)}th term is {insertSep($n)} " &
         &"and the highest prime needed is {insertSep($p)}."

  # Update count table.
  if n < 250: counts.inc(n)

  # Find next term of the sequence.
  if (n and 1) == 0:
    n = n shr 1
  else:
    p = sieve.nextPrime(p)
    inc n, p

echo()
echo "Numbers under 250 which don’t occur in the first 100_000_000 terms:"
for n in 1..249:
  if n notin counts:
    stdout.write "  ", n
echo '\n'

echo "Numbers under 250 which occur the most in the first 100_000_000 terms:"
counts.sort()
let largest = counts.largest[1]
for (n, count) in counts.pairs:
  if count == largest:
      stdout.write "  ", n
  else:
    # No more value with the largest number of occurrences.
    echo()
    break
