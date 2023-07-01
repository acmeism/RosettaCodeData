import math

const N = 2_200

template isOdd(n: int): bool = (n and 1) != 0

var r = newSeq[bool](N + 1)

for a in 1..N:
  for b in a..N:
    if a.isOdd and b.isOdd: continue
    let aabb = a * a + b * b
    for c in b..N:
      let aabbcc = aabb + c * c
      d = sqrt(aabbcc.float).int
      if aabbcc == d * d and d <= N: r[d] = true

for i in 1..N:
  if not r[I]: stdout.write i, " "
echo()
