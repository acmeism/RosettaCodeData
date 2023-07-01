import times

let t0 = cpuTime()

####################################################################################################
# Build list of primes.

const
  NPrimes = 1_000_000
  N = 16 * NPrimes

var sieve: array[(N - 1) div 2 + 1, bool]   # False (default) means prime.

for i, composite in sieve:
  if not composite:
    let n = 2 * i + 3
    for k in countup(n * n, N, 2 * n):
      sieve[(k - 3) div 2] = true

var primes = @[2]
for i, composite in sieve:
  if not composite:
    primes.add 2 * i + 3

if primes.len < NPrimes:
  quit "Not enough primes. Please, increase value of N."


####################################################################################################
# Compute primorial.

import strformat
import bignum

const LastToPrint = NPrimes

iterator primorials(): Int =
  ## Yield successive primorial numbers.
  var prim = newInt(1)
  yield prim
  for p in primes:
    prim *= p
    yield prim

var n = 0
for prim in primorials():
  echo &"primorial({n}) = {prim}"
  inc n
  if n == 10: break

n = 0
var nextToPrint = 10
for prim in primorials():
  if n == nextToPrint:
    echo &"primorial({n}) has {($prim).len} digits"
    if nextToPrint == LastToPrint: break
    nextToPrint *= 10
  inc n

echo ""
echo &"Total time: {cpuTime() - t0:.2f} s"
