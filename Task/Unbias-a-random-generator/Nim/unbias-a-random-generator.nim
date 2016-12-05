import math, strutils
randomize()

template newSeqWith(len: int, init: expr): expr =
  var result {.gensym.} = newSeq[type(init)](len)
  for i in 0 .. <len:
    result[i] = init
  result

proc randN(n): (proc: range[0..1]) =
  result = proc(): range[0..1] =
    if random(n) == 0: 1 else: 0

proc unbiased(biased): range[0..1] =
  var (this, that) = (biased(), biased())
  while this == that:
    this = biased()
    that = biased()
  return this

for n in 3..6:
  var biased = randN(n)
  var v = newSeqWith(1_000_000, biased())
  var cnt0, cnt1 = 0
  for x in v:
    if x == 0: inc cnt0
    else:      inc cnt1
  echo "Biased(",n,")  = count1=",cnt1,", count0=",cnt0,", percent=",
       formatFloat(100 * float(cnt1)/float(cnt1+cnt0), ffDecimal, 3)

  v = newSeqWith(1_000_000, unbiased(biased))
  cnt0 = 0
  cnt1 = 0
  for x in v:
    if x == 0: inc cnt0
    else:      inc cnt1
  echo "  Unbiased = count1=",cnt1,", count0=",cnt0,", percent=",
       formatFloat(100 * float(cnt1)/float(cnt1+cnt0), ffDecimal, 3)
