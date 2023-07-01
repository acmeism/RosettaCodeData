import std/[math, strformat]

# Task.

func isPrime(n: int): bool =
  if n < 2: return false
  if n == 2 or n == 3: return true
  if n mod 2 == 0: return false
  if n mod 3 == 0: return false
  var d = 5
  var step = 2
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, step
    step = 6 - step
  return true

echo "First 10 factorial primes:\n"
var count = 0
var n = 1
while count < 10:
  let f = fac(n)
  if isPrime(f - 1):
    inc count
    echo &"{count:>2}: {n:>3}! - 1 = {f - 1}"
  if count < 10 and isPrime(f + 1):
    inc count
    echo &"{count:>2}: {n:>3}! + 1 = {f + 1}"
  inc n


# Stretch.

import integers

func str(n: Integer): string =
  ## Return the string representation of an Integer.
  result = $n
  if result.len > 40:
      result = &"{result[0..19]}...{result[^20..^1]} ({result.len} digits)"

echo "\n\nNext 20 factorial primes:\n"
while count < 30:
  let f: Integer = factorial(n)
  if isPrime(f - 1):
    inc count
    echo &"{count:>2}: {n:>3}! - 1 = {str(f - 1)}"
  if isPrime(f + 1):
    inc count
    echo &"{count:>2}: {n:>3}! - 1 = {str(f + 1)}"
  inc n
