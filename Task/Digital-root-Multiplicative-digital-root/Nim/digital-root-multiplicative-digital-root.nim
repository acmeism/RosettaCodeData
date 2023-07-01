import strutils, sequtils, sugar

proc mdroot(n: int): tuple[mp, mdr: int] =
  var mdr = @[n]
  while mdr[mdr.high] > 9:
    var n = 1
    for dig in $mdr[mdr.high]:
      n *= parseInt($dig)
    mdr.add n
  (mdr.high, mdr[mdr.high])

for n in [123321, 7739, 893, 899998]:
  echo align($n, 6)," ",mdroot(n)
echo ""

var table = newSeqWith(10, newSeq[int]())
for n in 0..int.high:
  if table.map((x: seq[int]) => x.len).min >= 5: break
  table[mdroot(n).mdr].add n

for mp, val in table:
  echo mp, ": ", val[0..4]
