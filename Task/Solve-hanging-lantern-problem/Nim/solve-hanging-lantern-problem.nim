import std/[os, strutils]

proc sequenceCount(columns: var seq[int]): int =
  for icol in 1..columns.high:
    if columns[icol] > 0:
      dec columns[icol]
      inc result, sequenceCount(columns)
      inc columns[icol]
  if result == 0: result = 1

let ncol = paramCount()
if ncol == 0:
  quit "Missing parameters.", QuitFailure
var columns = newSeq[int](ncol + 1)   # We will ignore the first column.
for i in 1..ncol:
  let n = paramStr(i).parseInt()
  if n < 0:
    quit "Wrong number of lanterns.", QuitFailure
  columns[i] = n

echo columns.sequenceCount()
