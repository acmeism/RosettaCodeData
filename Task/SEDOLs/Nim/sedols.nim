proc c2v(c: char): int =
  assert c notin "AEIOU"
  if c < 'A': ord(c) - ord('0') else: ord(c) - ord('7')

const weight = [1, 3, 1, 7, 3, 9]

proc checksum(sedol: string): char =
  var val = 0
  for i, ch in sedol:
    val += c2v(ch) * weight[i]
  result = chr((10 - val mod 10) mod 10 + ord('0'))

for sedol in ["710889", "B0YBKJ", "406566", "B0YBLH",
              "228276", "B0YBKL", "557910", "B0YBKR",
              "585284", "B0YBKT", "B00030"]:
  echo sedol, " → ", sedol & checksum(sedol)
