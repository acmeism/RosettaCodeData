const n = 15
var t = newSeq[int](n + 2)

t[1] = 1
for i in 1..n:
  for j in countdown(i, 1): t[j] += t[j-1]
  t[i+1] = t[i]
  for j in countdown(i+1, 1): t[j] += t[j-1]
  stdout.write t[i+1] - t[i], " "
