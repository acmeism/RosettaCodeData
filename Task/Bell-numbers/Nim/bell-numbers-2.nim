iterator b(): int =
  ## Iterator yielding the bell numbers.
  var row = @[1]
  yield 1
  yield 1
  while true:
    var newRow = newSeq[int](row.len + 1)
    newRow[0] = row[^1]
    for i in 1..newRow.high:
      newRow[i] = newRow[i - 1] + row[i - 1]
    row = move(newRow)
    yield row[^1]   # The last value of the row is one step ahead of the first one.

iterator bellTriangle(): seq[int] =
  ## Iterator yielding the rows of the Bell triangle.
  var row = @[1]
  yield row
  while true:
    var newRow = newSeq[int](row.len + 1)
    newRow[0] = row[^1]
    for i in 1..newRow.high:
      newRow[i] = newRow[i - 1] + row[i - 1]
    row = move(newRow)
    yield row

when isMainModule:

  import strformat
  import strutils

  const Limit = 25      # Maximum index beyond which an overflow occurs.

  echo "Bell numbers from B0 to B25:"
  var i = 0
  for n in b():
    echo fmt"{i:2d}: {n:>20d}"
    inc i
    if i > Limit:
      break

  echo "\nFirst ten rows of Bell triangle:"
  i = 0
  for row in bellTriangle():
    inc i
    var line = ""
    for val in row:
      line.addSep(" ", 0)
      line.add(fmt"{val:6d}")
    echo line
    if i == 10:
      break
