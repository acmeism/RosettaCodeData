import math, strformat, tables

func primes(n: Positive): seq[int] =
  ## Return the list of prime divisors of "n".
  var n = n.int
  for d in 2..n:
    var q = n div d
    var m = n mod d
    while m == 0:
      result.add d
      n = q
      q = n div d
      m = n mod d

func isPrime(n: Positive): bool =
  ## Return true if "n" is prime.
  if n < 2: return false
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d <= sqrt(n.toFloat).int:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true

func pisanoPeriod(m: Positive): int =
  ## Calculate the Pisano period of 'm' from first principles.
  var p = 0
  var c = 1
  for i in 0..<m*m:
    p = (p + c) mod m
    swap p, c
    if p == 0 and c == 1: return i + 1
  result = 1

func pisanoPrime(p, k: Positive): int =
  ## Calculate the Pisano period of p^k where 'p' is prime and 'k' is a positive integer.
  if p.isPrime: p^(k-1) * p.pisanoPeriod() else: 0

func pisano(m: Positive): int =
  ## Calculate the Pisano period of 'm' using pisanoPrime.
  let primes = m.primes
  var primePowers = primes.toCountTable
  var pps: seq[int]
  for k, v in primePowers.pairs:
    pps.add pisanoPrime(k, v)
  if pps.len == 0: return 1
  result = pps[0]
  for i in 1..pps.high:
    result = lcm(result, pps[i])


when isMainModule:

  for p in 2..14:
    let pp = pisanoPrime(p, 2)
    if pp > 0:
      echo &"pisanoPrime({p:2}, 2) = {pp}"

  echo()
  for p in 2..179:
    let pp = pisanoPrime(p, 1)
    if pp > 0:
      echo &"pisanoPrime({p:3}, 1) = {pp}"

  echo()
  echo "pisano(n) for integers 'n' from 1 to 180 are:"
  for n in 1..180:
    stdout.write &"{pisano(n):3}", if n mod 15 == 0: '\n' else: ' '
