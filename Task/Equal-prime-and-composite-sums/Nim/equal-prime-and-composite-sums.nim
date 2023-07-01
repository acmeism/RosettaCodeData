import std/[bitops, math, monotimes, strformat, strutils, times]

type Sieve = object
  data: seq[byte]

proc `[]`(sieve: Sieve; idx: Positive): bool =
  ## Return the sieve element at index "idx".
  let idx = idx shr 1
  let iByte = idx shr 3
  let iBit = idx and 7
  result = sieve.data[iByte].testBit(iBit)

proc `[]=`(sieve: var Sieve; idx: Positive; val: bool) =
  ## Set the sieve element at index "idx" with value "val".
  let idx = idx shr 1
  let iByte = idx shr 3
  let iBit = idx and 7
  if val: sieve.data[iByte].setBit(iBit)
  else: sieve.data[iByte].clearBit(iBit)

proc newSieve(lim: Positive): Sieve =
  ## Create a sieve with maximum index "lim".
  result.data = newSeq[byte]((lim + 16) shr 4)

const Limit = 400_000_000

let t0 = getMonoTime()

# Fill the sieve.
var composite = newSieve(Limit)
for n in countup(3, sqrt(Limit.toFloat).int, 2):
  if not composite[n]:
    for k in countup(n * n, Limit - 1, 2 * n):
      composite[k] = true

proc isPrime(n: Positive): bool =
  ## Return true is "n" is prime.
  assert n >= 2
  if (n and 1) == 0: return n == 2
  result = not composite[n]

proc updatePrime(np, ip, psum: var int) =
  ## Find the next prime number and update "np", "ip" and "psum".
  inc np, 1
  while np <= Limit and not np.isPrime:
    inc np
  inc ip
  inc psum, np

proc updateComposite(nc, ic, csum: var int) =
  ## Find the next composite number and update "nc", "ic" and "csum".
  inc nc, 1
  while nc <= Limit and nc.isPrime:
    inc nc
  inc ic
  inc csum, nc

echo "          Sum         |   Prime Index   | Composite Index "
echo "──────────────────────────────────────────────────────────"

var np = 2      # Current prime.
var nc = 4      # Current composite.
var ip, ic = 1  # Ranks of current prime and composite.
var psum = np   # Current sum of prime numbers.
var csum = nc   # Current sum of composite numbers.

while true:
  if psum == csum:
    echo &"{insertSep($psum):>21} | {insertSep($ip):>15} | {insertSep($ic):>15}"
    updatePrime(np, ip, psum)
    updateComposite(nc, ic, csum)
  elif psum < csum:
    updatePrime(np, ip, psum)
  else:
    updateComposite(nc, ic, csum)
  if np > Limit or nc > Limit:
    break

echo()
let dt = toParts(getMonoTime() - t0)
echo &"Elapsed time: {dt[Seconds]}.{dt[Milliseconds]} s"
