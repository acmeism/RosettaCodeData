import math, strformat

func endsWithOne(n: Natural): bool =
  var n = n
  while true:
    var sum = 0
    while n > 0:
      let digit = n mod 10
      sum += digit * digit
      n = n div 10
    if sum == 1: return true
    if sum == 89: return false
    n = sum

const Ks = [7, 8, 11, 14, 17]

for k in Ks:
  var sums = newSeq[int64](k * 81 + 1)  # Initialized to 0s.
  sums[0] = 1
  for n in 1..k:
    for i in countdown(n * 81, 1):
      for j in 1..9:
        let s = j * j
        if s > i: break
        sums[i] += sums[i - s]

  var count1 = 0i64
  for i in 1..k*81:
    if i.endsWithOne(): count1 += sums[i]
  let limit = 10^k - 1
  echo &"For k = {k} in the range 1 to {limit}"
  echo &"{count1} numbers produce 1 and {limit - count1} numbers produce 89\n"
