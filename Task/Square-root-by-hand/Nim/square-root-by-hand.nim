import math
import bignum

var
  i = newInt(2)
  j = newInt(sqrt(2.0).int)
  k, d = j
  n = 500
let n0 = n
while true:
  stdout.write d
  i = (i - k * d) * 100
  k = 20 * j
  d = newInt(1)
  while d <= 10:
    if (k + d) * d > i:
      dec d, 1
      break
    inc d, 1
  j = j * 10 + d
  inc k, d
  if n0 > 0: dec n
  if n == 0: break
