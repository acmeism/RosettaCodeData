const ROWS = 10
const TRILEN = toInt(ROWS * (ROWS + 1) / 2) # Sum of arth progression
var triangle = newSeqOfCap[Natural](TRILEN) # Avoid reallocations

proc printPascalTri(row: Natural, result: var seq[Natural]) =
  add(result, 1)
  for i in 2..row-1: add(result, result[^row] + result[^(row-1)])
  add(result, 1)

  echo result[^row..^1]
  if row + 1 <= ROWS: printPascalTri(row + 1, result)

printPascalTri(1, triangle)
