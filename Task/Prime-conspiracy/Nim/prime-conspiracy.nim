# Prime conspiracy.

import std/[algorithm, math, sequtils, strformat, tables]

const N = 1_020_000_000     # Size of sieve of Eratosthenes.

proc newSieve(): seq[bool] =
  ## Create a sieve with only odd values.
  ## Index "i" in sieve represents value "n = 2 * i + 3".
  result.setLen(N)
  for item in result.mitems: item = true
  # Apply sieve.
  var i = 0
  const Limit = sqrt(2 * N.toFloat + 3).int
  while true:
    let n = 2 * i + 3
    if n > Limit:
      break
    if result[i]:
      # Found prime, so eliminate multiples.
      for k in countup((n * n - 3) div 2, N - 1, n):
        result[k] = false
    inc i

var isPrime = newSieve()

proc countTransitions(isPrime: seq[bool]; nprimes: int) =
  ## Build the transition count table and print it.

  var counts = [(2, 3)].toCountTable()    # Count of transitions.
  var d1 = 3      # Last digit of first prime in transition.
  var count = 2   # Count of primes (starting with 2 and 3).
  for i in 1..isPrime.high:
    if isPrime[i]:
      inc count
      let d2 = (2 * i + 3) mod 10   # Last digit of second prime in transition.
      counts.inc((d1, d2))
      if count == nprimes: break
      d1 = d2

  # Check if sieve was big enough.
  if count < nprimes:
    echo &"Found only {count} primes; expected {nprimes} primes. Increase value of N."
    quit(QuitFailure)

  # Print result.
  echo &"{nprimes} first primes. Transitions prime (mod 10) → next-prime (mod 10)."
  for key in sorted(counts.keys.toSeq):
    let count = counts[key]
    let freq = count.toFloat * 100 / nprimes.toFloat
    echo &"{key[0]} → {key[1]}    Count: {count:7d}     Frequency: {freq:4.2f}%"
  echo ""

isPrime.countTransitions(10_000)
isPrime.countTransitions(1_000_000)
isPrime.countTransitions(100_000_000)
