import hailstone, tables

var t = initCountTable[int]()

for i in 1 .. <100_000:
  t.inc(hailstone(i).len)

let (val, cnt) = t.largest()
echo "The length of hailstone sequence that is most common for"
echo "hailstone(n) where 1<=n<100000, is ", val, ". It occurs ", cnt, " times."
