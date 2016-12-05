import math, sequtils

iterator eqindex(data) =
  var suml, ddelayed = 0
  var sumr = sum(data)
  for i,d in data:
    suml += ddelayed
    sumr -= d
    ddelayed = d
    if suml == sumr:
      yield i

const d = @[@[-7, 1, 5, 2, -4, 3, 0],
            @[2, 4, 6],
            @[2, 9, 2],
            @[1, -1, 1, -1, 1, -1, 1]]

for data in d:
  echo "d = ", data
  echo "eqIndex(d) -> ", toSeq(eqindex(data))
