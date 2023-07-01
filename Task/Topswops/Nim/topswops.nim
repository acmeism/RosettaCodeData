import strformat

const maxBest = 32
var best: array[maxBest, int]

proc trySwaps(deck: seq[int], f, d, n: int) =
  if d > best[n]:
    best[n] = d

  for i in countdown(n - 1, 0):
    if deck[i] == -1 or deck[i] == i:
      break
    if d + best[i] <= best[n]:
      return

  var deck2 = deck
  for i in 1..<n:
    var k = 1 shl i
    if deck2[i] == -1:
      if (f and k) != 0:
        continue
    elif deck2[i] != i:
      continue

    deck2[0] = i
    for j in countdown(i - 1, 0):
      deck2[i - j] = deck[j]
    trySwaps(deck2, f or k, d + 1, n)

proc topswops(n: int): int =
  assert(n > 0 and n < maxBest)
  best[n] = 0
  var deck0 = newSeq[int](n + 1)
  for i in 1..<n:
    deck0[i] = -1
  trySwaps(deck0, 1, 0, n)
  best[n]

for i in 1..10:
  echo &"{i:2}: {topswops(i):2}"
