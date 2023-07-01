import iterutils, bigints

proc lfact: iterator: BigInt =
  result = iterator: BigInt =
    yield 0.initBigInt
    var
      fact = 1.initBigInt
      sum = 0.initBigInt
      n = 1.initBigInt
    while true:
      sum += fact
      fact *= n
      n += 1
      yield sum

echo "first 11:\n  "
for i in lfact().slice(last = 10):
  echo "  ", i

echo "20 through 110 (inclusive) by tens:"
for i in lfact().slice(20, 110, 10):
  echo "  ", i

echo "Digits in 1,000 through 10,000 (inclusive) by thousands:"
for i in lfact().slice(1_000, 10_000, 1_000):
  echo "  ", ($i).len
