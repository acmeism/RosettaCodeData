import std/[algorithm, math, strformat]

const N = 500_000

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

func initPowers(lim: Natural): seq[int] =
  ## Build list of powers of 2.
  var n = 1
  for i in 0..log2(N.toFloat).int:
    result.add n
    n = n shl 1

func initDePolignac(primes, powers: seq[int]): seq[int] =
  ## Build list of de Polignac numbers using a sieve
  ## for odd numbers.
  var sieve: array[0..(N div 2), bool]
  sieve.fill(true)
  for p1 in primes:
    for p2 in powers:
      if p1 + p2 <= N:
        sieve[(p1 + p2) shr 1] = false
  for i, isDePolignac in sieve:
    if isDePolignac:
      result.add i shl 1 + 1

let primes = initPrimes(N)
let powers = initPowers(N)
let dePolignac = initDePolignac(primes, powers)

echo "First 50 de Polignac numbers:"
for i in 0..49:
  stdout.write &"{dePolignac[i]:>4}"
  stdout.write if i mod 10 == 9: '\n' else: ' '
echo()

for i in [1000, 10000]:
  echo &"The {i:>5}th de Polignac number is {dePolignac[i-1]:>6}"
