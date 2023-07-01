# Abelian sandpile.

from math import sqrt
from nimPNG import savePNG24
from sequtils import repeat
from strformat import fmt
from strutils import strip, addSep, parseInt

# The grid represented as a sequence of sequences of int32.
type Grid = seq[seq[int32]]

# Colors to use for PPM and PNG files.
const Colors = [[byte 100,  40,  15],
                [byte 117,  87,  30],
                [byte 181, 134,  47],
                [byte 245, 182,  66]]

#---------------------------------------------------------------------------------------------------

func sideLength(initVal: int32): int32 =
  # Return the grid side length needed for "initVal" particles.
  # We make sure that the returned value is odd.
  result = sqrt(initVal.toFloat / 1.75).int32 + 3
  result += result and 1 xor 1

#---------------------------------------------------------------------------------------------------

func doOneStep(grid: var Grid; boundary: var array[4, int]): bool =
  ## Compute one step.

  result = false

  for y in boundary[0]..boundary[2]:
    for x in boundary[1]..boundary[3]:
      if grid[y][x] >= 4:

        let rem = grid[y][x] div 4
        grid[y][x] = grid[y][x] mod 4

        if y - 1 >= 0:
          inc grid[y - 1][x], rem
          if y == boundary[0]:
            dec boundary[0]

        if x - 1 >= 0:
          inc grid[y][x - 1], rem
          if x == boundary[1]:
            dec boundary[1]

        if y + 1 < grid.len:
          inc grid[y + 1][x], rem
          if y == boundary[2]:
            inc boundary[2]

        if x + 1 < grid.len:
          inc grid[y][x + 1], rem
          if x == boundary[3]:
            inc boundary[3]

        result = true

#---------------------------------------------------------------------------------------------------

proc display(grid: Grid; initVal: int) =
  ## Display the grid as an array of values.

  echo fmt"Starting with {initVal} particles."
  echo ""

  var line = newStringOfCap(2 * grid.len - 1)
  for row in grid:
    for value in row:
      line.addSep(" ", 0)
      line.add($value)
    echo line
    line.setLen(0)
  echo ""

#---------------------------------------------------------------------------------------------------

proc writePpmFile(grid: Grid; name: string) =
  ## Write a grid representation in a PPM file.

  var file = open(name, fmWrite)
  file.write(fmt"P6 {grid.len} {grid.len} 255 ")

  for row in grid:
    for value in row:
      discard file.writeBytes(Colors[value], 0, 3)

  file.close()
  echo fmt"PPM image written in ""{name}""."

#---------------------------------------------------------------------------------------------------

proc writePngFile(grid: Grid; name: string) =
  ## Write a grid representation in a PNG file.

  var pixels = newSeq[byte](3 * grid.len * grid.len)

  # Build pixel list.
  var idx = 0
  for row in grid:
    for value in row:
      pixels[idx..idx+2] = Colors[value]
      inc idx, 3

  discard savePNG24(name, pixels, grid.len, grid.len)
  echo fmt"PNG image written in ""{name}""."

#---------------------------------------------------------------------------------------------------

proc askInitVal(): int32 =
  # Ask user for the number of particles.

  while true:
    stdout.write("Number of particles? ")
    try:
      let input = stdin.readLine().strip().parseInt()
      if input in 4..int32.high:
        return input.int32
      echo fmt"Value not in expected range: 4..{int32.high}"
    except ValueError:
      echo "Invalid input"
    except EOFError:
      quit(QuitSuccess)

#---------------------------------------------------------------------------------------------------

# Initialize the grid.
let initVal = askInitVal()
let sideLen = sideLength(initVal)
var grid = repeat(newSeq[int32](sideLen), sideLen)
let origin = grid.len div 2
var boundaries: array[4, int] = [origin, origin, origin, origin]
grid[origin][origin] = initVal

# Run the simulation.
while doOneStep(grid, boundaries):
  discard

# Display grid.
if grid.len <= 20:
  grid.display(initVal)
#grid.writePpmFile(fmt"grid_{initVal}.ppm")
grid.writePngFile(fmt"grid_{initVal}.png")
