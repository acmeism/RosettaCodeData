import strformat
import strutils

func chowla(n: uint64): uint64 =
  var sum = 0u64
  var i = 2u64
  var j: uint64
  while i * i <= n:
    if n mod i == 0:
      j = n div i
      sum += i
      if i != j:
        sum += j
    inc i
  sum

for n in 1u64..37:
  echo &"chowla({n}) = {chowla(n)}"

var count = 0
var power = 100u64
for n in 2u64..10_000_000:
  if chowla(n) == 0:
    inc count
  if n mod power == 0:
    echo &"There are {insertSep($count, ','):>7} primes < {insertSep($power, ','):>10}"
    power *= 10

count = 0
const limit = 350_000_000u64
var k = 2u64
var kk = 3u64
var p: uint64
while true:
  p = k * kk
  if p > limit:
    break
  if chowla(p) == p - 1:
    echo &"{insertSep($p, ','):>10} is a perfect number"
    inc count
  k = kk + 1
  kk += k
echo &"There are {count} perfect numbers < {insertSep($limit, ',')}"
