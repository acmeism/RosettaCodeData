proc identityMatrix(n): auto =
  result = newSeq[seq[int]](n)
  for i in 0 .. < result.len:
    result[i] = newSeq[int](n)
    result[i][i] = 1
