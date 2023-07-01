import math, strformat, strutils

const N = 35_000

# Sieve.
var composite: array[0..N, bool]  # Default is false and means prime.
composite[0] = true
composite[1] = true
for n in 2..sqrt(N.toFloat).int:
  if not composite[n]:
    for k in countup(n * n, N, n):
      composite[k] = true


func digits(n: Positive): seq[0..9] =
  var n = n.int
  while n != 0:
    result.add n mod 10
    n = n div 10


proc isSPDS(n: int): bool =
  if composite[n]: return false
  result = true
  for d in n.digits:
    if composite[d]: return false


iterator spds(maxCount: Positive): int {.closure.} =
  yield 2
  var count = 1
  var n = 3
  while count != maxCount and n <= N:
    if n.isSPDS:
      inc count
      yield n
    inc n, 2
  if count != maxCount:
    quit &"Too few values ({count}). Please, increase value of N.", QuitFailure


stdout.write "The first 25 SPDS are:"
for n in spds(25):
  stdout.write ' ', n
echo()

var count = 0
for n in spds(100):
  inc count
  if count == 100:
    echo "The 100th SPDS is: ", n
