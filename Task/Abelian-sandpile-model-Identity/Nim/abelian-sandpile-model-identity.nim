import sequtils
import strutils

type SandPile = array[3, array[3, int]]

#---------------------------------------------------------------------------------------------------

iterator neighbors(i, j: int): tuple[a, b: int] =
  ## Yield the indexes of the neighbours of cell at indexes (i, j).
  if i > 0:
    yield (i - 1, j)
  if i < 2:
    yield (i + 1, j)
  if j > 0:
    yield (i, j - 1)
  if j < 2:
    yield (i, j + 1)

#---------------------------------------------------------------------------------------------------

proc print(s: openArray[SandPile]) =
  ## Print a list of sandpiles.
  for i in 0..2:
    for n, sp in s:
      if n != 0:
        stdout.write(if i == 1: " ⇨ " else: "   ")
      stdout.write(sp[i].join(" "))
    stdout.write('\n')

#---------------------------------------------------------------------------------------------------

proc printSum(s1, s2, s3: SandPile) =
  ## Print "s1 + s2 = s3".
  for i in 0..2:
    stdout.write(s1[i].join(" "))
    stdout.write(if i == 1: " + " else: "   ", s2[i].join(" "))
    stdout.write(if i == 1: " = " else: "   ", s3[i].join(" "))
    stdout.write('\n')

#---------------------------------------------------------------------------------------------------

func isStable(sandPile: SandPile): bool =
  ## Return true if the sandpile is stable, else false.
  result = true
  for row in sandPile:
    if row.anyit(it > 3):
      return false

#---------------------------------------------------------------------------------------------------

proc topple(sandPile: var SandPile) =
  ## Eliminate one value > 3, propagating a grain to each neighbor.
  for i, row in sandPile:
    for j, val in row:
      if val > 3:
        dec sandPile[i][j], 4
        for (i, j) in neighbors(i, j):
          inc sandPile[i][j]
        return

#---------------------------------------------------------------------------------------------------

proc stabilize(sandPile: var SandPile) =
  ## Stabilize a sandpile.
  while not sandPile.isStable():
    sandPile.topple()

#---------------------------------------------------------------------------------------------------

proc `+`(s1, s2: SandPile): SandPile =
  ## Add two sandpiles, stabilizing the result.
  for row in 0..2:
    for col in 0..2:
      result[row][col] = s1[row][col] + s2[row][col]
  result.stabilize()

#---------------------------------------------------------------------------------------------------

const Separator = "\n-----\n"

echo "Avalanche\n"
var s: SandPile = [[4, 3, 3], [3, 1, 2], [0, 2, 3]]
var list = @[s]
while not s.isStable():
  s.topple()
  list.add(s)
list.print()
echo Separator

echo "s1 + s2 == s2 + s1\n"
let s1 = [[1, 2, 0], [2, 1, 1], [0, 1, 3]]
let s2 = [[2, 1, 3], [1, 0, 1], [0, 1, 0]]
printSum(s1, s2, s1 + s2)
echo ""
printSum(s2, s1, s2 + s1)
echo Separator

echo "s3 + s3_id == s3\n"
let s3 = [[3, 3, 3], [3, 3, 3], [3, 3, 3]]
let s3_id = [[2, 1, 2], [1, 0, 1], [2, 1, 2]]
printSum(s3, s3_id, s3 + s3_id)
echo Separator

echo "s3_id + s3_id = s3_id\n"
printSum(s3_id, s3_id, s3_id + s3_id)
