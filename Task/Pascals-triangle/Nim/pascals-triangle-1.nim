import sequtils, strutils

proc printPascalTriangle(n: int) =
  ## Print a Pascal triangle.

  # Build the triangle.
  var triangle: seq[seq[int]]
  triangle.add @[1]
  for _ in 1..<n:
    triangle.add zip(triangle[^1] & @[0], @[0] & triangle[^1]).mapIt(it[0] + it[1])

  # Build the lines to display.
  let length = len($max(triangle[^1]))  # Maximum length of number.
  var lines: seq[string]
  for row in triangle:
    lines.add row.mapIt(($it).center(length)).join(" ")

  # Display the lines.
  let lineLength = lines[^1].len    # Length of largest line (the last one).
  for line in lines:
    echo line.center(lineLength)

printPascalTriangle(10)
