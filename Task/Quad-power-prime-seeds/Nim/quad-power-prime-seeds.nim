import std/[strformat, strutils]
import integers

func isQuadPowerPrimeSeeds(n: Integer): bool =
  var p = newInteger(n)
  var n1 = n + 1
  for _ in 1..4:
    if not isPrime(p + n1): return false
    p *= n
  result = true

const N = 1_000_000

echo "First 30 quad-power prime seeds:"
var count = 0
var n = 1
var limit = N
while true:
  if n.isQuadPowerPrimeSeeds():
    inc count
    if count <= 50:
      stdout.write &"{n:7}"
      stdout.write if count mod 10 == 0: '\n' else: ' '
      if count == 50: echo()
    elif n > limit:
      echo &"First quad-power prime seed greater than {insertSep($limit)} " &
           &"is {insertSep($n)} at position {count}."
      inc limit, N
      if limit > 3 * N: break
  inc n
