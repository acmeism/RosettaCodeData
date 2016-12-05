const boardSize = 8

proc underAttack(col, queens): bool =
  if col in queens: return true
  for i, x in queens:
    if abs(col - x) == queens.len - i:
      return true
  return false

proc solve(n): auto =
  result = newSeq[seq[int]]()
  result.add(@[])
  var newSolutions = newSeq[seq[int]]()
  for row in 1..n:
    for solution in result:
      for i in 1..boardSize:
        if not underAttack(i, solution):
          newSolutions.add(solution & i)
    swap result, newSolutions
    newSolutions.setLen(0)

for answer in solve(boardSize):
  for i, x in answer:
    if i > 0: stdout.write ", "
    stdout.write "(",i,", ",x,")"
