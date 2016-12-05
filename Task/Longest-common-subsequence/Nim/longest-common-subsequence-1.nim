proc lcs(x, y): string =
  if x == "" or y == "":
    return ""

  if x[0] == y[0]:
    return x[0] & lcs(x[1..x.high], y[1..y.high])

  let a = lcs(x, y[1..y.high])
  let b = lcs(x[1..x.high], y)
  result = if a.len > b.len: a else: b

echo lcs("1234", "1224533324")
echo lcs("thisisatest", "testing123testing")
