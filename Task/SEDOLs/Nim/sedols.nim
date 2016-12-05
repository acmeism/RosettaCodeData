import strutils

proc c2v(c): int =
  assert c notin "AEIOU"
  let a = ord(c)
  if a < 65: a - 48
  else: a - 55

const weight = [1,3,1,7,3,9]

proc checksum(sedol): string =
  var tmp = 0
  for i,s in sedol:
    tmp += c2v(s) * weight[i]
  result = $((10 - (tmp mod 10)) mod 10)

for sedol in """710889
B0YBKJ
406566
B0YBLH
228276
B0YBKL
557910
B0YBKR
585284
B0YBKT
B00030""".splitLines():
  echo sedol, checksum(sedol)
