import math

var ls: seq[float] = @[]
for x in 1..1000:
  ls.add(1.0 / float(x * x))
echo sum(ls)
