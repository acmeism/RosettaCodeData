import strutils

proc printMinCells(n: Positive) =
  echo "Minimum number of cells after, before, above and below $1 x $1 square:".format(n)
  var cells = newSeq[int](n)
  for r in 0..<n:
    for c in 0..<n:
      cells[c] = min([n - r - 1, r, c, n - c - 1])
    echo cells.join(" ")

when isMainModule:
  for n in [10, 9, 2, 1]:
    printMinCells(n)
    echo()
