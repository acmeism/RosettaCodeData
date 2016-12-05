import strutils

proc count(s: string, sub: char): int =
  var i = 0
  while true:
    i = s.find(sub, i)
    if i < 0:
      break
    inc i
    inc result

proc popcount(n): int = n.toBin(64).count('1')

const primes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61}

var p = newSeq[int]()
var i = 0
while p.len < 25:
  if popcount(i) in primes: p.add i
  inc i

echo p

p = @[]
i = 888_888_877
while i <= 888_888_888:
  if popcount(i) in primes: p.add i
  inc i

echo p
