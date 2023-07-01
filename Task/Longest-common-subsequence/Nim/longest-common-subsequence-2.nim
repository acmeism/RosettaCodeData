proc lcs(a, b: string): string =
  var ls = newSeq[seq[int]](a.len+1)
  for i in 0 .. a.len:
    ls[i].newSeq(b.len+1)

  for i, x in a:
    for j, y in b:
      if x == y:
        ls[i+1][j+1] = ls[i][j] + 1
      else:
        ls[i+1][j+1] = max(ls[i+1][j], ls[i][j+1])

  result = ""
  var x = a.len
  var y = b.len
  while x > 0 and y > 0:
    if ls[x][y] == ls[x-1][y]:
      dec x
    elif ls[x][y] == ls[x][y-1]:
      dec y
    else:
      assert a[x-1] == b[y-1]
      result = a[x-1] & result
      dec x
      dec y

echo lcs("1234", "1224533324")
echo lcs("thisisatest", "testing123testing")
