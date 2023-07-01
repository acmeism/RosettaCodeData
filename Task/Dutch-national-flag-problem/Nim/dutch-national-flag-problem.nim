import os, random, strutils

type Color {.pure.} = enum Red = "R", White = "W", Blue = "B"

#---------------------------------------------------------------------------------------------------

proc isSorted(a: openArray[Color]): bool =
  # Check if an array of colors is in the order of the dutch national flag.
  var prevColor = Red
  for color in a:
    if color < prevColor:
      return false
    prevColor = color
  return true

#---------------------------------------------------------------------------------------------------

proc threeWayPartition(a: var openArray[Color]; mid: Color) =
  ## Dijkstra way to sort the colors.
  var i, j = 0
  var k = a.high
  while j <= k:
    if a[j] < mid:
      swap a[i], a[j]
      inc i
      inc j
    elif a[j] > mid:
      swap a[j],  a[k]
      dec k
    else:
      inc j

#———————————————————————————————————————————————————————————————————————————————————————————————————

var n: Positive = 10

# Get the number of colors.
if paramCount() > 0:
  try:
    n = paramStr(1).parseInt()
    if n <= 1:
      raise newException(ValueError, "")
  except ValueError:
    echo "Wrong number of colors"
    quit(QuitFailure)

# Create the colors.
randomize()
var colors = newSeqOfCap[Color](n)

while true:
  for i in 0..<n:
    colors.add(Color(rand(ord(Color.high))))
  if not colors.isSorted():
    break
  colors.setLen(0)  # Reset for next try.

echo "Original: ", colors.join("")

# Sort the colors.
var sortedColors = colors
threeWayPartition(sortedColors, White)
doAssert sortedColors.isSorted()
echo "Sorted:   ", sortedColors.join("")
