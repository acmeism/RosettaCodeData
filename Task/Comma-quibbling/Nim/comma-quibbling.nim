proc commaQuibble(s): string =
  result = ""
  for i, c in s:
    if i > 0: result.add (if i < s.high: ", " else: " and ")
    result.add c
  result = "{" & result & "}"

var s = @[@[], @["ABC"], @["ABC", "DEF"], @["ABC", "DEF", "G", "H"]]
for i in s:
  echo commaQuibble(i)
