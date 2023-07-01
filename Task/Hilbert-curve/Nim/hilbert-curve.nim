const
  Level = 4
  Side = (1 shl Level) * 2 - 2

type Direction = enum E, N, W, S

const

  # Strings to use according to direction.
  Drawings1: array[Direction, string] = ["──", " │", "──", " │"]

  # Strings to use according to old and current direction.
  Drawings2: array[Direction, array[Direction, string]] = [["──", "─╯", " ?", "─╮"],
                                                           [" ╭", " │", "─╮", " ?"],
                                                           [" ?", " ╰", "──", " ╭"],
                                                           [" ╰", " ?", "─╯", " │"]]

type Curve = object
  grid: array[-Side..1, array[0..Side, string]]
  x, y: int
  dir, oldDir: Direction

proc newCurve(): Curve =
  ## Create a new curve.
  result.x = 0
  result.y = 0
  result.dir = E
  result.oldDir = E
  for row in result.grid.mitems:
    for item in row.mitems:
      item = "  "

proc left(dir: var Direction) =
  ## Turn on the left.
  dir = if dir == S: E else: succ(dir)

proc right(dir: var Direction) =
  ## Turn on the right.
  dir = if dir == E: S else: pred(dir)

proc move(curve: var Curve) =
  ## Move to next position according to current direction.
  case curve.dir
  of E: inc curve.x
  of N: dec curve.y
  of W: dec curve.x
  of S: inc curve.y

proc forward(curve: var Curve) =
  # Do one step: draw a corner, draw a segment and advance to next corner.

  # Draw corner.
  curve.grid[curve.y][curve.x] = Drawings2[curve.oldDir][curve.dir]
  curve.move()

  # Draw segment.
  curve.grid[curve.y][curve.x] = Drawings1[curve.dir]

  # Advance to next corner.
  curve.move()
  curve.oldDir = curve.dir

# Forward reference.
proc b(curve: var Curve; level: int)

proc a(curve: var Curve; level: int) =
  ## "A" function.
  if level > 0:
    curve.dir.left()
    curve.b(level - 1)
    curve.forward()
    curve.dir.right()
    curve.a(level - 1)
    curve.forward()
    curve.a(level - 1)
    curve.dir.right()
    curve.forward()
    curve.b(level - 1)
    curve.dir.left()

proc b(curve: var Curve; level: int) =
  ## "B" function.
  if level > 0:
    curve.dir.right()
    curve.a(level - 1)
    curve.forward()
    curve.dir.left()
    curve.b(level - 1)
    curve.forward()
    curve.b(level - 1)
    curve.dir.left()
    curve.forward()
    curve.a(level - 1)
    curve.dir.right()

### Main code

var curve = newCurve()

# Draw.
curve.a(Level)

# Print.
for row in curve.grid:
  for s in row:
    stdout.write(s)
  stdout.writeLine("")
