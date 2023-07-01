# Longest common substring.

import sequtils

func lcs(a, b: string): string =
  var lengths = newSeqWith(a.len, newSeq[int](b.len))
  var greatestLength = 0
  for i, x in a:
    for j, y in b:
      if x == y:
        lengths[i][j] = if i == 0 or j == 0: 1 else: lengths[i - 1][j - 1] + 1
        if lengths[i][j] > greatestLength:
          greatestLength = lengths[i][j]
          result = a[(i - greatestLength + 1)..i]

echo lcs("thisisatest", "testing123testing")
