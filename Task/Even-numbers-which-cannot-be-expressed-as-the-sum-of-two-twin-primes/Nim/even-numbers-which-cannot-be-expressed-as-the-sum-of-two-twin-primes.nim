import std/[strformat, sugar]

const Limit = 100_000

func isPrime(n: Natural): bool =
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var k = 5
  var delta = 2
  while k * k <= n:
    if n mod k == 0: return false
    inc k, delta
    delta = 6 - delta
  result = true

let primes = collect:
               for n in countup(5, Limit, 2):
                 if n.isPrime: n

var twins = @[3]
for i in 0..<primes.high:
  if primes[i + 1] - primes[i] == 2:
    if twins[^1] != primes[i]:
      twins.add primes[i]
    twins.add primes[i + 1]

func nonTwinSums(twins: seq[int]): seq[int] =
  var sieve = newSeq[bool](Limit + 1)
  for i in 0..twins.high:
    for j in i..twins.high:
      let sum = twins[i] + twins[j]
      if sum > Limit: break
      sieve[sum] = true
  var i = 2
  while i <= Limit:
    if not sieve[i]:
      result.add i
    inc i, 2

echo "Non twin prime sums:"
var ntps = nonTwinSums(twins)
for i, n in ntps:
  stdout.write &"{n:4}"
  stdout.write if i mod 10 == 9: '\n' else: ' '
echo &"\nFound {ntps.len}.\n"

echo "Non twin prime sums (including 1):"
twins.insert(1, 0)
ntps = nonTwinSums(twins)
for i, n in ntps:
  stdout.write &"{n:4}"
  stdout.write if i mod 10 == 9: '\n' else: ' '
echo &"\nFound {ntps.len}.\n"
