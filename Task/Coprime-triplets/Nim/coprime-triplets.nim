import math, strutils

var list = @[1, 2]

while true:
  var n = 3
  let prev2 = list[^2]
  let prev1 = list[^1]
  while n in list or gcd(n, prev2) != 1 or gcd(n, prev1) != 1:
    inc n
  if n >= 50: break
  list.add n

echo list.join(" ")
