proc dif(s): seq[int] =
  result = newSeq[int](s.len-1)
  for i, x in s[1..s.high]:
    result[i] = x - s[i]

proc difn(s, n): seq[int] =
  if n > 0: difn(dif(s), n-1)
  else: s

const s = @[90, 47, 58, 29, 22, 32, 55, 5, 55, 73]
echo difn(s, 0)
echo difn(s, 1)
echo difn(s, 2)
