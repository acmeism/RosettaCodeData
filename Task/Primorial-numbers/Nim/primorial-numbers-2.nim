import std/monotimes

let t0 = getMonoTime()

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

import strformat, threadpool
import bignum

const NWorkers = 8


proc computeProduct(a: openArray[int]): Int =
  result = newInt(1)
  for n in a: result *= n


proc primorial(n: int): Int =
  if n == 0: return newInt(1)

  # Prepare sublists.
  var input: array[NWorkers, seq[int]]
  for i in 0..<n:
    input[i mod NWorkers].add primes[i]

  # Spawn workers and get partial products.
  var responses: array[NWorkers, FlowVar[Int]]
  for i in 0..<NWorkers:
    responses[i] = spawn computeProduct(input[i])

  # Compute final product.
  result = ^responses[0]
  for i in 1..<NWorkers:
    result *= ^responses[i]


for n in 0..9:
  echo &"primorial({n}) = {primorial(n)}"

for n in [10, 100, 1_000, 10_000, 1_000_000]:
  echo &"primorial({n}) has {len($primorial(n))} digits"

echo ""
echo &"Total time: {(getMonoTime() - t0)}"
