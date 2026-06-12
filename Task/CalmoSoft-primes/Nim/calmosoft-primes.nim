import std/[algorithm, math, strformat, strutils]

func initPrimes(lim: Natural): seq[int] =
  ## Build list of primes using a sieve of Erathostenes.
  var composite = newSeq[bool]((lim + 1) shr 1)
  composite[0] = true
  for n in countup(3, int(sqrt(lim.toFloat)), 2):
    if not composite[n shr 1]:
      for k in countup(n * n, lim, 2 * n):
        composite[k shr 1] = true
  result.add 2
  for n in countup(3, lim, 2):
    if not composite[n shr 1]:
      result.add n

func isPrime(n: Natural): bool =
  ## Return "true" is "n" is prime.
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  var step = 2
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, step
    step = 6 - step
  return true

const Max = 50_000_000
let primes = initPrimes(Max)

proc calmoPrimes(limit: Positive): (int, seq[int], seq[int], seq[int]) =
  ## Find the longest sequence of CalmoSoft primes up to "limit".
  let phigh = primes.upperBound(limit) - 1
  var sum1 = sum(primes.toOpenArray(0, phigh))
  var longest = 0
  var sIndices, eIndices, sums: seq[int]
  for i in 0..phigh:
    if phigh - i + 1 < longest:
      break
    if i > 0:
      dec sum1, primes[i - 1]
    let isEven = i == 0
    var sum2 = sum1
    for j in countdown(phigh, i):
      let temp = j - i + 1
      if temp < longest:
        break
      if j < phigh:
        dec sum2, primes[j + 1]
      if ((temp and 1) == 0) != isEven:
        continue
      if sum2.isPrime:
        if temp > longest:
          longest = temp
          sIndices = @[i]
          eIndices = @[j]
          sums = @[sum2]
        else:
          sIndices.add i
          eIndices.add j
          sums.add sum2
        break
  result = (longest, sIndices, eIndices, sums)

func plural(lg: int): (string, string) =
  ## Return the singular or plural form according to value of "lg".
  result = if lg == 1: ("", "is") else: ("s", "are")


for limit in [100, 250, 5000, 10000, 500000, 50000000]:
  let (longest, sIndices, eIndices, sums) = calmoPrimes(limit)
  let (p1, p2) = plural(sums.len)
  echo &"For primes up to {insertSep($limit)} the longest sequence{p1} of CalmoSoft primes"
  echo &"having a length of {insertSep($longest)} {p2}:\n"
  for i in 0..sIndices.high:
    let cp = primes[sIndices[i]..eIndices[i]]
    echo &"{cp[0..5].join(\" + \")} + ... + {cp[^6..^1].join(\" + \")} = {sums[i]}"
    echo()
