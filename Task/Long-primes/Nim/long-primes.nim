import strformat


func sieve(limit: int): seq[int] =

  var composite = newSeq[bool](limit + 1)
  var p = 3
  var p2 = p * p
  while p2 < limit:
    if not composite[p]:
      for n in countup(p2, limit, 2 * p):
        composite[n] = true
    inc p, 2
    p2 = p * p

  for n in countup(3, limit, 2):
    if not composite[n]:
      result.add n


func period(n: int): int =
  ## Find the period of the reciprocal of "n".
  var r = 1
  for i in 1..(n + 1):
    r = 10 * r mod n
  let r1 = r
  while true:
    r = 10 * r mod n
    inc result
    if r == r1: break


let primes = sieve(64000)
var longPrimes: seq[int]
for prime in primes:
  if prime.period() == prime - 1:
    longPrimes.add prime

const Numbers = [500, 1000, 2000, 4000, 8000, 16000, 32000, 64000]
var index, count = 0
var totals = newSeq[int](Numbers.len)
for longPrime in longPrimes:
  if longPrime > Numbers[index]:
    totals[index] = count
    inc index
  inc count
totals[^1] = count

echo &"The long primes up to {Numbers[0]} are:"
for i in 0..<totals[0]:
  stdout.write ' ', longPrimes[i]
stdout.write '\n'

echo "\nThe number of long primes up to:"
for i, total in totals:
  echo &"  {Numbers[i]:>5} is {total}"
