import sequtils, strutils

# Creating a sequence containing sequences of integers.
var s1 = newSeq[seq[int]](5)
for item in s1.mitems: item = @[1]
echo "s1 = ", s1   # @[@[1], @[1], @[1], @[1], @[1]]
s1[0].add 2
echo "s1 = ", s1   # @[@[1, 2], @[1], @[1], @[1], @[1]]

# Using newSeqWith.
var s2 = newSeqWith(5, @[1])
echo "s2 = ", s2   # @[@[1], @[1], @[1], @[1], @[1]]
s2[0].add 2
echo "s2 = ", s2   # @[@[1, 2], @[1], @[1], @[1], @[1]]

# Creating a sequence containing pointers.
proc newInt(n: int): ref int =
  new(result)
  result[] = n
var s3 = newSeqWith(5, newInt(1))
echo "s3 contains references to ", s3.mapIt(it[]).join(", ")   # 1, 1, 1, 1, 1
s3[0][] = 2
echo "s3 contains references to ", s3.mapIt(it[]).join(", ")   # 2, 1, 1, 1, 1

# How to create non distinct elements.
let p = newInt(1)
var s4 = newSeqWith(5, p)
echo "s4 contains references to ", s4.mapIt(it[]).join(", ")   # 1, 1, 1, 1, 1
s4[0][] = 2
echo "s4 contains references to ", s4.mapIt(it[]).join(", ")   # 2, 2, 2, 2, 2
