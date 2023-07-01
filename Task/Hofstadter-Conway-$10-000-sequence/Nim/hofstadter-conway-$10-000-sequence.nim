import strutils

const last = 1 shl 20

var aList: array[last + 1, int]
aList[0..2] = [-50_000, 1, 1]
var
  v    = aList[2]
  k1   = 2
  lg2  = 1
  aMax = 0.0

for n in 3..last:
  v = aList[v] + aList[n-v]
  aList[n] = v
  aMax = max(aMax, v.float / n.float)
  if (k1 and n) == 0:
    echo "Maximum between 2^$# and 2^$# was $#".format(lg2, lg2+1, aMax)
    aMax = 0
    inc lg2
  k1 = n
