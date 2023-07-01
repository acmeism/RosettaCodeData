import math, strformat, strutils

const Lim = 1_000_035

type Group {.pure.} = enum        # "ord" gives the number of terms.
  Unsexy = (1, "unsexy primes")
  Pairs = (2, "sexy prime pairs")
  Triplets = (3, "sexy prime triplets")
  Quadruplets = (4, "sexy prime quadruplets")
  Quintuplets = (5, "sexy prime quintuplets")


# Sieve of Erathosthenes.
var composite: array[1..Lim, bool]                # Default is false.
composite[1] = true
for p in countup(3, sqrt(Lim.toFloat).int, 2):    # Ignore even numbers.
  if not composite[p]:
    for k in countup(p * p, Lim, 2 * p):
      composite[k] = true

template isPrime(n: int): bool = not composite[n]


proc expandGroup(n: int; group: Group): string =
  ## Given the first term of a group, return the full group
  ## representation as a string.
  var n = n
  for _ in 1..ord(group):
    result.addSep(", ")
    result.add $n
    inc n, 6
  if group != Unsexy: result = '(' & result & ')'


proc printResult(group: Group; values: seq[int]; count: int) =
  ## Print a result.

  echo &"\nNumber of {group} less than {Lim}: {values.len}"
  let last = min(values.len, count)
  let verb = if last == 1: "is" else: "are"
  echo &"The last {last} {verb}:"

  var line = ""
  for i in countdown(last, 1):
    line.addSep(", ")
    line.add expandGroup(values[^i], group)
  echo "    ", line


var
  pairs, trips, quads, quints: seq[int]  # Keep only the first prime of the group.
  unsexy = @[2, 3]

for n in countup(3, Lim, 2):
  if composite[n]: continue

  if n in 7..(Lim - 8) and composite[n - 6] and composite[n + 6]:
    unsexy.add n
    continue

  if n < Lim - 6 and isPrime(n + 6):
    pairs.add n
  else: continue

  if n < Lim - 12 and isPrime(n + 12):
    trips.add n
  else: continue

  if n < Lim - 18 and isPrime(n + 18):
    quads.add n
  else: continue

  if n < Lim - 24 and isPrime(n + 24):
    quints.add n

printResult(Pairs, pairs, 5)
printResult(Triplets, trips, 5)
printResult(Quadruplets, quads, 5)
printResult(Quintuplets, quints, 5)
printResult(Unsexy, unsexy, 10)
