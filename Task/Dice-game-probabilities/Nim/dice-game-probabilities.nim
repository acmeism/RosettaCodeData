import bignum
from math import sum

proc counts(ndices, nsides: int): seq[int] =
  result.setlen(ndices * nsides + 1)
  for i in 1..nsides:
    result[i] = 1
  for i in 1..<ndices:
    var c = newSeq[int](result.len)
    for sum in i..(i * nsides):
      for val in 1..nsides:
        inc c[sum + val], result[sum]
    result = move(c)

proc probabilities(counts: seq[int]): seq[Rat] =
  result.setLen(counts.len)
  let total = sum(counts)
  for i, n in counts:
    result[i] = newRat(n, total)

proc beatingProbability(ndices1, nsides1, ndices2, nsides2: int): Rat =
  let counts1 = counts(ndices1, nsides1)
  let counts2 = counts(ndices2, nsides2)
  var p1 = counts1.probabilities()
  var p2 = counts2.probabilities()

  result = newRat(0)
  for sum1 in ndices1..p1.high:
    var p = newRat(0)
    for sum2 in ndices2..min(sum1 - 1, p2.high):
      p += p2[sum2]
    result += p1[sum1] * p

echo beatingProbability(9, 4, 6, 6).toFloat
echo beatingProbability(5, 10, 6, 7).toFloat
