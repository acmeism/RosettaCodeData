import math

const N = 1_000_000

# Sieve of Erathostenes.
var isPrime: array[2..N, bool]
for item in isPrime.mitems: item = true

# Initialize the sieve.
for n in 2..int(sqrt(N.toFloat)):
  if isPrime[n]:
    for k in countup(n * n, N, n):
      isPrime[k] = false

#---------------------------------------------------------------------------------------------------

func reversed(n: int): int =
  ## Return the reversed number in base 10 representation.
  var n = n
  while true:
    result = 10 * result + n mod 10
    n = n div 10
    if n == 0:
      break

#---------------------------------------------------------------------------------------------------

iterator emirps(): int =
  ## Yield the emirps.
  for n, prime in isPrime:
    if prime:
      let r = reversed(n)
      if r > N:
        break   # Unable to continue.
      if r != n and isPrime[r]:
        yield n

#———————————————————————————————————————————————————————————————————————————————————————————————————

stdout.write "First 20 emirps:"
var count = 0
for n in emirps():
  stdout.write ' ', n
  inc count
  if count == 20:
    echo ""
    break

stdout.write "Emirps between 7700 and 8000:"
for n in emirps():
  if n in 7700..8000:
    stdout.write ' ', n
  elif n > 8000:
    echo ""
    break

stdout.write "The 10000th emirp: "
count = 0
for n in emirps():
  inc count
  if count == 10000:
    echo n
    break
if count < 10000:
  echo "Not enough primes. Increase value of N."
