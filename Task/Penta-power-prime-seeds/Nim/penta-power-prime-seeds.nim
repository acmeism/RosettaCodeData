import std/[strformat, strutils]
import integers

func isPentaPowerPrimeSeeds(n: Integer): bool =
  var p = newInteger(1)
  var n1 = n + 1
  for _ in 0..4:
    if not isPrime(p + n1): return false
    p *= n
  result = true

const N = 10_000_000

echo "First 30 penta-power prime seeds:"
var count = 0
var n = 1
while true:
  if n.isPentaPowerPrimeSeeds():
    inc count
    if count <= 30:
      stdout.write &"{n:7}"
      stdout.write if count mod 6 == 0: '\n' else: ' '
      if count == 30: echo()
    elif n > N:
      echo &"First penta-power prime seed greater than {insertSep($N)} " &
           &"is {insertSep($n)} at position {count}."
      break
  inc n, 2
