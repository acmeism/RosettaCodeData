import std/[math, strformat, strutils, sugar, tables]

###############################################################################
#  List of primes.

const Lim = 100_000

proc primes(lim: static Positive): seq[int] {.compileTime.} =
  ## Build the list of primes from 2 to "lim".

  # Use a sieve of Eratosthenes.
  var sieve: array[lim div 2, bool]
  var p = 3
  while p * p < lim:
    if not sieve[(p - 3) div 2]:
      for k in countup(p * p, lim, 2 * p):
        sieve[(k - 3) div 2] = true
    inc p, 2

  # Build the list of primes.
  result = @[2]
  for p in countup(3, lim, 2):
    if not sieve[(p - 3) div 2]:
      result.add p

const Primes = primes(Lim)


###############################################################################

type
  PrimePower = tuple[prime, power: int]
  PrimePowers = seq[PrimePower]


proc primePowers(n: Positive): PrimePowers =
  var n = n
  for p in Primes:
    if p * p > n: break
    var count = 0
    while n mod p == 0:
      n = n div p
      inc count
    if count != 0:
      result.add (p, count)
  if n != 1: result.add (n, 1)


proc phi(p, r: Positive): int =
  p ^ (r - 1) * (p - 1)


var cache = {1: 1, 2: phi(2, 1), 4: phi(2, 2)}.toTable


proc carmichaelHelper(p, r: Positive): int =
  let n = p ^ r
  if n in cache: return cache[n]
  result = if p > 2: phi(p, r) else: phi(p, r - 1)
  cache[n] = result


proc carmichaelLambda(n: Positive): int =
  if n in cache: return cache[n]
  let pps = primePowers(n)
  if pps.len == 1:
    let (p, r) = pps[0]
    result = if p > 2: phi(p, r) else: phi(p, r - 1)
  else:
    let a = collect(for (p, r) in pps: carmichaelHelper(p, r))
    result = lcm(a)
  cache[n] = result


proc iterationsToOne(n: Positive): int =
  var n = n
  while n > 1:
    n = carmichaelLambda(n)
    inc result


when isMainModule:

  echo " n   λ   k"
  echo "----------"
  for n in 1..25:
    echo &"{n:>2}  {carmichaelLambda(n):>2}  {iterationsToOne(n):>2}"

  echo "\nIterations to 1       i     lambda(i)"
  echo "====================================="
  var n = 1
  for i in 0..16:
    while iterationsToOne(n) != i:
      inc n
    echo &"{i:>4} {insertSep($n):>18} {insertSep($carmichaelLambda(n)):>12}"
