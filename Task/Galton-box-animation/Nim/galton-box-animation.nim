import random, strutils

const
  BoxW = 41         # Galton box width.
  BoxH = 37         # Galton box height.
  PinsBaseW = 19    # Pins triangle base.
  NMaxBalls = 55    # Number of balls.

const CenterH = PinsBaseW + (BoxW - (PinsBaseW * 2 - 1)) div 2 - 1

type

  Cell = enum
    cEmpty = " "
    cBall = "o"
    cWall = "|"
    cCorner = "+"
    cFloor = "-"
    cPin = "."

  # Galton box. Will be printed upside-down.
  Box = array[BoxH, array[BoxW, Cell]]

  Ball = ref object
    x, y: int


func initBox(): Box =

  # Set ceiling and floor.
  result[0][0] = cCorner
  result[0][^1] = cCorner
  for i in 1..(BoxW - 2):
    result[0][i] = cFloor
  result[^1] = result[0]

  # Set walls.
  for i in 1..(BoxH - 2):
    result[i][0] = cWall
    result[i][^1] = cWall

  # Set rest to Empty initially.
  for i in 1..(BoxH - 2):
    for j in 1..(BoxW - 2):
      result[i][j] = cEmpty

  # Set pins.
  for nPins in 1..PinsBaseW:
    for p in 0..<nPins:
      result[BoxH - 2 - nPins][CenterH + 1 - nPins + p * 2] = cPin


func newBall(box: var Box; x, y: int): Ball =

  doAssert box[y][x] == cEmpty, "Tried to create a new ball in a non-empty cell"
  result = Ball(x: x, y: y)
  box[y][x] = cBall


proc doStep(box: var Box; b: Ball) =

  if b.y <= 0:
    return    # Reached the bottom of the box.

  case box[b.y-1][b.x]

  of cEmpty:
    box[b.y][b.x] = cEmpty
    dec b.y
    box[b.y][b.x] = cBall

  of cPin:
    box[b.y][b.x] = cEmpty
    dec b.y
    if box[b.y][b.x-1] == cEmpty and box[b.y][b.x+1] == cEmpty:
      inc b.x, 2 * rand(1) - 1
    elif box[b.y][b.x-1] == cEmpty:
      inc b.x
    else:
      dec b.x
    box[b.y][b.x] = cBall

  else:
    # It's frozen - it always piles on other balls.
    discard


proc draw(box: Box) =
  for r in countdown(BoxH - 1, 0):
    echo box[r].join()


#———————————————————————————————————————————————————————————————————————————————————————————————————

randomize()
var box = initBox()
var balls: seq[Ball]

for i in 0..<(NMaxBalls + BoxH):

  echo "Step ", i, ':'
  if i < NMaxBalls:
    balls.add box.newBall(CenterH, BoxH - 2)
  box.draw()

  # Next step for the simulation.
  # Frozen balls are kept in balls slice for simplicity.
  for ball in balls:
    box.doStep(ball)
