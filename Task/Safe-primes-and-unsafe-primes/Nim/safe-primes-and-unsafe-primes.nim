import sequtils, strutils

const N = 10_000_000

# Erathostene's Sieve. Only odd values are represented. False value means prime.
var sieve: array[N div 2 + 1, bool]
sieve[0] = true   # 1 is not prime.

for i in 1..sieve.high:
  if not sieve[i]:
    let n = 2 * i + 1
    for k in countup(n * n, N, 2 * n):
      sieve[k shr 1] = true


proc isprime(n: Positive): bool =
  ## Check if a number is prime.
  n == 2 or (n and 1) != 0 and not sieve[n shr 1]


proc classifyPrimes(): tuple[safe, unsafe: seq[int]] =
  ## Classify prime numbers in safe and unsafe numbers.
  for n in 2..N:
    if n.isprime():
      if (n shr 1).isprime():
        result[0].add n
      else:
        result[1].add n

when isMainModule:

  let (safe, unsafe) = classifyPrimes()

  echo "First 35 safe primes:"
  echo safe[0..<35].join(" ")
  echo "Count of safe primes below  1_000_000:",
      ($safe.filterIt(it < 1_000_000).len).insertSep(',').align(7)
  echo "Count of safe primes below 10_000_000:",
      ($safe.filterIt(it < 10_000_000).len).insertSep(',').align(7)

  echo "First 40 unsafe primes:"
  echo unsafe[0..<40].join(" ")
  echo "Count of unsafe primes below  1_000_000:",
      ($unsafe.filterIt(it < 1_000_000).len).insertSep(',').align(8)
  echo "Count of unsafe primes below 10_000_000:",
      ($unsafe.filterIt(it < 10_000_000).len).insertSep(',').align(8)
