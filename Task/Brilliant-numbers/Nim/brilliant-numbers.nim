import std/[algorithm, math, strformat, strutils]

func primes(lim: Natural): seq[Natural] =
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

func getPrimesByDigits(lim: Natural): seq[seq[Natural]] =
  ## Distribute primes according to their number of digits.
  var p = 10
  result.add @[]
  for prime in primes(lim):
    if prime > p:
      p *= 10
      if p > 10 * lim: break
      result.add @[]
    result[^1].add prime

let primesByDigits = getPrimesByDigits(10^9-1)

###

echo "First 100 brilliant numbers:"

var brilliantNumbers: seq[Natural]
for primes in primesByDigits:
  for i in 0..primes.high:
    for j in 0..i:
      brilliantNumbers.add primes[i] * primes[j]
  if brilliantNumbers.len >= 100: break
brilliantNumbers.sort()

for i in 0..99:
  stdout.write &"{brilliantNumbers[i]:>5}"
  if i mod 10 == 9: echo()
echo()


###

var power = 10
var count = 0
for p in 1..<(2 * primesByDigits.len):
  let primes = primesByDigits[p shr 1]
  var pos = count + 1
  var minProduct = int.high
  for i, p1 in primes:
    let j = primes.toOpenArray(i, primes.high).lowerBound((power + p1 - 1) div p1)
    let p2 = primes[i + j]
    let product = p1 * p2
    if product < minProduct:
      minProduct = product
    inc pos, j
    if p1 >= p2: break
  echo &"First brilliant number ⩾ 10^{p:<2} is {minProduct} at position {insertSep($pos)}"
  power *= 10
  if p mod 2 == 1:
    inc count, primes.len * (primes.len + 1) div 2
