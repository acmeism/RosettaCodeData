import random, sequtils, strformat

type randProc = proc: range[0..1]

randomize()

proc randN(n: Positive): randProc =
  result = proc: range[0..1] = ord(rand(n) == 0)

proc unbiased(biased: randProc): range[0..1] =
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
    if x == 0: inc cnt0 else: inc cnt1
  echo &"Biased({n}) → count1 = {cnt1}, count0 = {cnt0}, percent = {100*cnt1 / (cnt1+cnt0):.3f}"

  v = newSeqWith(1_000_000, unbiased(biased))
  cnt0 = 0
  cnt1 = 0
  for x in v:
    if x == 0: inc cnt0 else: inc cnt1
  echo &"Unbiased  → count1 = {cnt1}, count0 = {cnt0}, percent = {100*cnt1 / (cnt1+cnt0):.3f}"
