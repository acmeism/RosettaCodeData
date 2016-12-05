import strutils

proc floyd(rowcount = 5): seq[seq[int]] =
  result = @[@[1]]
  while result.len < rowcount:
    let n = result[result.high][result.high] + 1
    var row = newSeq[int]()
    for i in n .. n + result[result.high].len:
      row.add i
    result.add row

proc pfloyd(rows) =
  var colspace = newSeq[int]()
  for n in rows[rows.high]: colspace.add(($n).len)
  for row in rows:
    for i, x in row:
      stdout.write align($x, colspace[i])," "
    echo ""

echo floyd()

for i in [5, 14]:
  pfloyd(floyd(i))
  echo ""
