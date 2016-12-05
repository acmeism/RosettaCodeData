from math import sqrt

const N = 524_000_000.int32
var x = newSeq[int32](N+1)

for i in 2..sqrt(N.float).int32:
  var p = i*i
  x[p] += i
  var j = i + i
  while (p += i; p <= N):
    j.inc
    x[p] += j

for m in 4..N:
  let n = x[m] + 1
  if n < m and n != 0 and m == x[n] + 1:
      echo n, " ", m
