import math, strutils, sugar, tables

const
  N = 1_000_000_000
  S = sqrt(N.toFloat).int

var composite: array[3..S, bool]
for n in countup(3, S, 2):
  if n * n > S: break
  if not composite[n]:
    for k in countup(n * n, S, 2 * n):
      composite[k] = true

# Prime list. Add a dummy zero to start at index 1.
let primes = @[0, 2] & collect(newSeq, for n in countup(3, S, 2): (if not composite[n]: n))

var cache: Table[(Natural, Natural), Natural]

proc phi(x, a: Natural): Natural =
  if a == 0: return x
  let pair = (x, a)
  if pair in cache: return cache[pair]
  result = phi(x, a - 1) - phi(x div primes[a], a - 1)
  cache[pair] = result

proc π(n: Natural): Natural =
  if n <= 2: return 0
  let a = π(sqrt(n.toFloat).Natural)
  result = phi(n, a) + a - 1

var n = 1
for i in 0..9:
  echo "π(10^$1) = $2".format(i, π(n))
  n *= 10
