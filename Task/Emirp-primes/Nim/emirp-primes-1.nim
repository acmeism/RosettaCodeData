import math

# Increments to find the next divisor when testing primality.
const Incr = [4, 2, 4, 2, 4, 6, 2, 6]

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

func isPrime(n: int): bool =
  ## Check if a number is prime.
  ## We are already sure that "n" is not a multiple of 2, 3 or 5,
  ## so we don’t check the modulo.
  var k = 7
  var i = 0
  while k <= int(sqrt(n.toFloat)):
    if n mod k == 0:
      return false
    inc k, Incr[i]
    i = if i == Incr.high: 0 else: i + 1
  result = true

#---------------------------------------------------------------------------------------------------

iterator emirps(): int =
  ## Yield the emirps.
  var n = 13
  var i = 2   # Current index in the increment array.
  while true:
    # We find the reversed number first as it allows to eliminate candidates.
    let r = reversed(n)
    if r != n and r mod 10 in [1, 3, 7, 9] and n.isPrime and r.isPrime:
      yield n
    inc n, Incr[i]
    i = if i == Incr.high: 0 else: i + 1

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
