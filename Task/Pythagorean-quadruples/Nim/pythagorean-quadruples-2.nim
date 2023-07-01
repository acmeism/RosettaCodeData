const N = 2_200
const N2 = N * N * 2

var r = newSeq[bool](N + 1)

var ab = newSeq[bool](N2 + 1)
for a in 1..N:
  let a2 = a * a
  for b in a..N:
    ab[a2 + b * b] = true

var s = 3
for c in 1..N:
  var s1 = s
  s += 2
  var s2 = s
  for d in (c+1)..N:
    if ab[s1]: r[d] = true
    s1 += s2
    s2 += 2

for d in 1..N:
  if not r[d]: stdout.write d, " "
