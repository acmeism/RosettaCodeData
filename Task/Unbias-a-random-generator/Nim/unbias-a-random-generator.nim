import math, strutils
randomize()

template newSeqWith(len: int, init: expr): expr =
  var result {.gensym.} = newSeq[type(init)](len)
  for i in 0..<len:
    result[i] = init

proc randN(n): (proc: range[0..1]) =
  proc: range[0..1] = ord(random(n) == 0)

proc unbiased(biased): range[0..1] =
  result = biased()
  var that = biased()
  while result == that:
    result = biased()
    that = biased()

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
