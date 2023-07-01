import math, sets

iterator yellowstone(n: int): int =
  assert n >= 3
  for i in 1..3: yield i
  var present = [1, 2, 3].toHashSet
  var prevLast = 2
  var last = 3
  var start = 4
  for _ in 4..n:
    var candidate = start
    while true:
      if candidate notin present and gcd(candidate, last) == 1 and gcd(candidate, prevLast) != 1:
        yield candidate
        present.incl candidate
        prevLast = last
        last = candidate
        while start in present: inc start
        break
      inc candidate

for n in yellowstone(30):
  stdout.write " ", n
echo()
