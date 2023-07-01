import strformat, strutils
import bignum

const Limit = 11_000

# Build list of primes using "nextPrime" function from "bignum".
var primes: seq[int]
var p = newInt(2)
while p < Limit:
  primes.add p.toInt
  p = p.nextPrime()

# Build list of factorials.
var facts: array[Limit, Int]
facts[0] = newInt(1)
for i in 1..<Limit:
  facts[i] = facts[i - 1] * i

var sign = 1
echo " n: Wilson primes"
echo "—————————————————"
for n in 1..11:
  sign = -sign
  var wilson: seq[int]
  for p in primes:
    if p < n: continue
    let f = facts[n - 1] * facts[p - n] - sign
    if f mod (p * p) == 0:
      wilson.add p
  echo &"{n:2}:  ", wilson.join(" ")
