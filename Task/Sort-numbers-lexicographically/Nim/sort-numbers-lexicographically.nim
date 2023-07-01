import algorithm, sequtils

for n in [0, 5, 13, 21, -22]:
  let s = if n > 1: toSeq(1..n) else: toSeq(countdown(1, n))
  echo s.sortedByIt($it)
