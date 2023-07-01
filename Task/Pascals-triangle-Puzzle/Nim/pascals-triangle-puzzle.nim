import strutils

type

  BlockValue = object
    known: int
    x, y, z: int

  Variables = tuple[x, y, z: int]

func `+=`(left: var BlockValue; right: BlockValue) =
  ## Symbolically add one block to another.
  left.known += right.known
  left.x += right.x - right.z    # Z is excluded as n(Y - X - Z) = 0.
  left.y += right.y + right.z

proc toString(n: BlockValue; vars: Variables): string =
  ## Return the representation of the block value, when X, Y, Z are known.
  result = $(n.known + n.x * vars.x + n.y * vars.y + n.z * vars.z)

proc Solve2x2(a11, a12, b1, a21, a22, b2: int): Variables =
  ## Solve a puzzle, supposing an integer solution exists.
  if a22 == 0:
    result.x = b2 div a21
    result.y = (b1 - a11 * result.x) div a12
  else:
    result.x = (b1 * a22 - b2 * a12) div (a11 * a22 - a21 * a12)
    result.y = (b1 - a11 * result.x) div a12
  result.z = result.y - result.x

var blocks : array[1..5, array[1..5, BlockValue]]   # The lower triangle contains blocks.

# The bottom blocks.
blocks[5][1] = BlockValue(x: 1)
blocks[5][2] = BlockValue(known: 11)
blocks[5][3] = BlockValue(y: 1)
blocks[5][4] = BlockValue(known: 4)
blocks[5][5] = BlockValue(z: 1)

# Upward run.
for row in countdown(4, 1):
  for column in 1..row:
    blocks[row][column] += blocks[row + 1][column]
    blocks[row][column] += blocks[row + 1][column + 1]

# Now have known blocks 40=[3][1], 151=[1][1] and Y=X+Z to determine X,Y,Z.
let vars = Solve2x2(blocks[1][1].x,
                    blocks[1][1].y,
                    151 - blocks[1][1].known,
                    blocks[3][1].x,
                    blocks[3][1].y,
                    40 - blocks[3][1].known)

# Print the results.
for row in 1..5:
  var line = ""
  for column in 1..row:
    line.addSep(" ")
    line.add toString(blocks[row][column], vars)
  echo line
