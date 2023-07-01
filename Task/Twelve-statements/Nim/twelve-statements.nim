import bitops, sequtils, strformat, strutils, sugar

type Bools = array[1..12, bool]

const Predicates = [1:  (b: Bools) => b.len == 12,
                    2:  (b: Bools) => b[7..12].count(true) == 3,
                    3:  (b: Bools) => toSeq(countup(2, 12, 2)).mapIt(b[it]).count(true) == 2,
                    4:  (b: Bools) => not b[5] or b[6] and b[7],
                    5:  (b: Bools) => not b[2] and not b[3] and not b[4],
                    6:  (b: Bools) => toSeq(countup(1, 12, 2)).mapIt(b[it]).count(true) == 4,
                    7:  (b: Bools) => b[2] xor b[3],
                    8:  (b: Bools) => not b[7] or b[5] and b[6],
                    9:  (b: Bools) => b[1..6].count(true) == 3,
                    10: (b: Bools) => b[11] and b[12],
                    11: (b: Bools) => b[7..9].count(true) == 1,
                    12: (b: Bools) => b[1..11].count(true) == 4]


proc `$`(b: Bools): string =
  toSeq(1..12).filterIt(b[it]).join(" ")


echo "Exacts hits:"
var bools: Bools
for n in 0..4095:
  block check:
    for i in 1..12: bools[i] = n.testBit(12 - i)
    for i, predicate in Predicates:
      if predicate(bools) != bools[i]:
        break check
    echo "    ", bools

echo "\nNear misses:"
for n in 0..4095:
  for i in 1..12: bools[i] = n.testBit(12 - i)
  var count = 0
  for i, predicate in Predicates:
    if predicate(bools) == bools[i]: inc count
  if count == 11:
    for i, predicate in Predicates:
      if predicate(bools) != bools[i]:
        echo &"    (Fails at statement {i:2})  {bools}"
        break
