var count = 0
var n, c, c3 = 1

while count < 30:
  var sq = n * n
  while c3 < sq:
    inc c
    c3 = c * c * c
  if c3 == sq:
    echo sq, " is square and cube"
  else:
    echo sq
    inc count
  inc n
