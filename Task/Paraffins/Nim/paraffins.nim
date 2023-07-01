import bigints

const
  nMax: int32 = 250
  nBranches = 4

var rooted, unrooted: array[nMax + 1, BigInt]
rooted[0..1] = [1.initBigInt, 1.initBigInt]
unrooted[0..1] = [1.initBigInt, 1.initBigInt]
for i in 2 .. nMax:
  rooted[i] = 0.initBigInt
  unrooted[i] = 0.initBigInt

proc choose(m: BigInt; k: int32): BigInt =
  result = m
  if k == 1: return
  for i in 1 ..< k:
    result = result * (m + i) div (i + 1)

proc tree(br, n, l, sum: int32; cnt: BigInt) =
  var s: int32 = 0
  for b in br + 1 .. nBranches:
    s = sum + (b - br) * n
    if s > nMax: return

    let c = choose(rooted[n], b - br) * cnt

    if l * 2 < s: unrooted[s] += c
    if b == nBranches: return
    rooted[s] += c
    for m in countdown(n-1, 1):
      tree b, m, l, s, c

proc bicenter(s: int32) =
  if (s and 1) == 0:
    unrooted[s] += rooted[s div 2] * (rooted[s div 2] + 1) div 2

for n in 1 .. nMax:
  tree 0, n, n, 1, 1.initBigInt
  n.bicenter
  echo n, ": ", unrooted[n]
