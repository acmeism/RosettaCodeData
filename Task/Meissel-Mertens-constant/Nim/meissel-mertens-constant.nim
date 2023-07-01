import std/[math, strformat, strutils]

proc initPrimes(N: static int): seq[int] =
  ## Initialize the list of primes.

  const M = 2 * N - 1
  var composite = newSeq[bool](N)
  composite[0] = true   # 1 is not prime.

  # Conversions from index to value and value to index.
  template index(n: int): int = (n - 1) shr 1
  template value(idx: int): int = idx shl 1 + 1

  # Fill the sieve.
  var n = 3
  while n * n <= M:
    if not composite[n.index]:
      for k in countup(n * n, M, 2 * n):
        composite[k.index] = true
    inc n, 2

  # Build list of primes.
  result = @[2]
  for idx in 0..composite.high:
    if not composite[idx]:
      result.add idx.value


const N = 2^30
let primes = initPrimes(N)

echo "Primes added         M"
echo "────────────   ──────────────"
const γ = 0.57721566490153286   # Euler–Mascheroni constant.
let primeCount = primes.len
var sum = 0.0
var count = 0
for p in primes:
  let rp = 1 / p
  sum += ln(1 - rp) + rp
  inc count
  if count mod 10_000_000 == 0 or count == primeCount:
    echo &"{insertSep($count):>11}   {sum+γ:.12}"
