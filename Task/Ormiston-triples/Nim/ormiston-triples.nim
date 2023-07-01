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

func nextPrime(sieve: Sieve; n: int): int =
  ## Return next prime greater than "n".
  result = n
  while true:
    inc result
    if sieve.isPrime(result):
      return

func digits(n: Positive): seq[byte] =
  ## Return the sorted list of digits of "n".
  var n = n.Natural
  while n != 0:
    result.add byte(n mod 10)
    n = n div 10
  result.sort()

proc main() =

  const N = 10_000_000_000
  let sieve = initSieve(N)

  echo "Smallest member of the first 25 Ormiston triples:"
  var count = 0
  var limit = N div 10
  var p1 = 2

  while true:
    if p1 >= limit:
      echo &"Number of Ormiston pairs below {insertSep($limit)}: {count}"
      limit *= 10
      if limit > N: break
    # Check p1 and p2.
    let p2 = sieve.nextPrime(p1)
    if (p2 - p1) mod 18 != 0:
      p1 = p2
      continue
    # Check p2 and p3.
    let p3 = sieve.nextPrime(p2)
    if (p3 - p2) mod 18 != 0:
      p1 = p3   # Skip p2.
      continue
    # Check p1.digits and p2.digits.
    let d1 = p1.digits
    if p2.digits != d1:
      p1 = p2
      continue
    # Check p1.digits and p3.digits.
    if p3.digits != d1:
      p1 = p3   # Skip p2.
      continue
    # Ormiston triple found.
    inc count
    if count <= 25:
      stdout.write &"{p1:8}"
      stdout.write if count mod 5 == 0: '\n' else: ' '
      if count == 25: echo()
    # Try next.
    p1 = p2

main()
