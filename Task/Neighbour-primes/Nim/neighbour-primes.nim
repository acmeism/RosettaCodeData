import strformat, sugar

const
  Max1 = 499        # Maximum for first prime.
  Max2 = 251_000    # Maximum for sieve (in fact 250_999 = 499 * 503 + 2).

# Sieve of Erathosthenes: false (default) is composite.
var composite: array[3..Max2, bool]   # Ignore 2 as 2 * 3 + 8 is not prime.
var n = 3
while true:
  let n2 = n * n
  if n2 > Max2: break
  if not composite[n]:
    for k in countup(n2, Max2, 2 * n):
      composite[k] = true
  inc n, 2

template isPrime(n: int): bool = not composite[n]

let primes = collect(newSeq):
               for n in countup(3, Max2, 2):
                 if n.isPrime: n

var p = primes[0]
var i = 0
while p <= Max1:
  inc i
  let q = primes[i]
  if (p * q + 2).isPrime:
    echo &"{p:3} {q:3} {p*q+2:6}"
  p = q
