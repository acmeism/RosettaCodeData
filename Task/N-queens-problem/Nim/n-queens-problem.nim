const BoardSize = 8

proc underAttack(col: int; queens: seq[int]): bool =
  if col in queens: return true
  for i, x in queens:
    if abs(col - x) == queens.len - i:
      return true
  return false

proc solve(n: int): seq[seq[int]] =
  result = newSeq[seq[int]]()
  result.add(@[])
  var newSolutions = newSeq[seq[int]]()
  for row in 1..n:
    for solution in result:
      for i in 1..BoardSize:
        if not underAttack(i, solution):
          newSolutions.add(solution & i)
    swap result, newSolutions
    newSolutions.setLen(0)

echo "Solutions for a chessboard of size ", BoardSize, 'x', BoardSize
echo ""

for i, answer in solve(BoardSize):
  for row, col in answer:
    if row > 0: stdout.write ' '
    stdout.write chr(ord('a') + row), col
  stdout.write if i mod 4 == 3: "\n" else: "      "
