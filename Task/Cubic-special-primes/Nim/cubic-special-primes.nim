import math, strformat

func sieve(limit: Positive): seq[bool] =
  # True denotes composite, false denotes prime.
  result = newSeq[bool](limit + 1)   # All false by default.
  result[0] = true
  result[1] = true
  # No need to bother with even numbers over 2 for this task.
  var p = 3
  while true:
    let p2 = p * p
    if p2 > limit: break
    for i in countup(p2, limit, 2 * p):
      result[i] = true
    while true:
      inc p, 2
      if not result[p]: break

func isCube(n: int): bool =
  let s = cbrt(n.toFloat).int
  result = s * s * s == n

let c = sieve(14999)
echo "Cubic special primes under 15_000:"
echo " Prime1  Prime2    Gap  Cbrt"
var lastCubicSpecial = 3
var count = 1
echo &"{2:7} {3:7} {1:6} {1:4}"
for n in countup(5, 14999, 2):
  if c[n]: continue
  let gap = n - lastCubicSpecial
  if gap.isCube:
    let gapCbrt = cbrt(gap.toFloat).int
    echo &"{lastCubicSpecial:7} {n:7} {gap:6} {gapCbrt:4}"
    lastCubicSpecial = n
    inc count
echo &"\n{count + 1} such primes found."
