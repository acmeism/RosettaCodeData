func mrUnrank1(vec: var openArray[int]; rank, n: int) =
  if n < 1: return
  let q = rank div n
  let r = rank mod n
  swap vec[r], vec[n - 1]
  vec.mrUnrank1(q, n - 1)

func mrRank1(vec, inv: var openArray[int]; n: int): int =
  if n < 2: return 0
  let s = vec[n - 1]
  swap vec[n - 1], vec[inv[n - 1]]
  swap inv[s], inv[n - 1]
  result = s + n * vec.mrRank1(inv, n - 1)

func getPermutation(vec: var openArray[int]; rank: int) =
  for i in 0..vec.high: vec[i] = i
  vec.mrUnrank1(rank, vec.len)

func getRank(vec: openArray[int]): int =
  var v, inv = newSeq[int](vec.len)
  for i, val in vec:
    v[i] = val
    inv[val] = i
  result = v.mrRank1(inv, vec.len)


when isMainModule:

  import math, random, sequtils, strformat

  randomize()

  var tv3: array[3, int]
  for r in 0..5:
    tv3.getPermutation(r)
    echo &"{r:>2} → {tv3} → {tv3.getRank()}"

  echo ""
  var tv4: array[4, int]
  for r in 0..23:
    tv4.getPermutation(r)
    echo &"{r:>2} → {tv4} → {tv4.getRank()}"

  echo ""
  var tv12: array[12, int]
  for r in newSeqWith(4, rand(fac(12))):
    tv12.getPermutation(r)
    echo &"{r:>9} → {tv12} → {tv12.getRank()}"
