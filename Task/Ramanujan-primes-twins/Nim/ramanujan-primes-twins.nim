import math, sequtils, strutils, sugar, times

let t0 = now()

type PrimeCounter = seq[int32]

proc initPrimeCounter(limit: Positive): PrimeCounter {.noInit.} =
  doAssert limit > 1
  result = repeat(1i32, limit)
  result[0] = 0
  result[1] = 0
  for i in countup(4, limit - 1, 2): result[i] = 0
  var p = 3
  var p2 = 9
  while p2 < limit:
    if result[p] != 0:
      for q in countup(p2, limit - 1, p + p):
        result[q] = 0
    inc p, 2
    p2 = p * p
  # Compute partial sums in place.
  var sum = 0i32
  for item in result.mitems:
    sum += item
    item = sum

func ramanujanMax(n: int): int {.inline.} = int(ceil(4 * n.toFloat * ln(4 * n.toFloat)))

func ramanujanPrime(pi: PrimeCounter; n: int): int =
  if n == 1: return 2
  var max = ramanujanMax(n)
  if (max and 1) == 1: dec max
  for i in countdown(max, 2, 2):
    if pi[i] - pi[i div 2] < n:
      return i + 1

func primesLe(limit: Positive): seq[int] =
  var composite = newSeq[bool](limit + 1)
  var n = 3
  var n2 = 9
  while n2 <= limit:
    if not composite[n]:
      for k in countup(n2, limit, 2 * n):
        composite[k] = true
    n2 += (n + 1) shl 2
    n += 2
  result = @[2]
  for n in countup(3, limit, 2):
    if not composite[n]: result.add n

proc main() =
  const Lim = 1_000_000
  let pi = initPrimeCounter(1 + ramanujanMax(Lim))
  let rpLim = ramanujanPrime(pi, Lim)
  echo "The 1_000_000th Ramanujan prime is $#.".format(($rpLim).insertSep())
  let r = primesLe(rpLim)
  var c = r.mapIt(pi[it] - pi[it div 2])
  var ok = c[^1]
  for i in countdown(c.len - 2, 0):
    if c[i] < ok:
      ok = c[i]
    else:
      c[i] = 0
  let fr = collect(newSeq, for i, p in r: (if c[i] != 0: p))
  var twins = 0
  var prev = -1
  for p in fr:
    if p == prev + 2: inc twins
    prev = p
  echo "There are $1 twins in the first $2 Ramanujan primes.".format(($twins).insertSep(), ($Lim).insertSep)

main()
echo "\nElapsed time: ", (now() - t0).inMilliseconds, " ms"
