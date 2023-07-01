import bigints

proc sumMults(first: int32, limit: BigInt): BigInt =
  var last = limit - 1
  last -= last mod first
  (last div first) * (last + first) div 2

proc sum35(n: BigInt): BigInt =
  result = sumMults(3, n)
  result += sumMults(5, n)
  result -= sumMults(15, n)

var x = 1.initBigInt
while x < "1000000000000000000000000000000".initBigInt:
  echo sum35 x
  x *= 10
