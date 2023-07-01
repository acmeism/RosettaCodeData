import strformat
import tables

# Generate tables at compile time. This eliminates the initialization at
# the expense of a bigger executable.

const square13 = block:
  var tmp = newSeq[tuple[a, b: int]]()
  for i in 1..13:
    tmp.add((i * i, i))
  toTable(tmp)

const square10000 = block:
  var tmp = newSeq[tuple[a, b: int]]()
  for i in 1..10000:
    tmp.add((i * i, i))
  toTable(tmp)

proc solve(angle, maxLen: int, allowSame: bool): seq[tuple[a, b, c: int]] =
  result = newSeq[tuple[a, b, c: int]]()
  for a in 1..maxLen:
    for b in a..maxLen:
      var lhs = a * a + b * b
      if angle != 90:
        case angle
        of 60:
          dec lhs, a * b
        of 120:
          inc lhs, a * b
        else:
          raise newException(IOError, "Angle must be 60, 90 or 120 degrees")
      case maxLen
      of 13:
        var c = square13.getOrDefault(lhs)
        if (not allowSame and a == b and b == c) or c == 0:
          continue
        result.add((a, b, c))
      of 10000:
        var c = square10000.getOrDefault(lhs)
        if (not allowSame and a == b and b == c) or c == 0:
          continue
        result.add((a, b, c))
      else:
        raise newException(IOError, "Maximum length must be either 13 or 10000")

echo "For sides in the range [1, 13] where they can all be the same length:\n"
let angles = [90, 60, 120]
for angle in angles:
  var solutions = solve(angle, 13, true)
  echo fmt"    For an angle of {angle} degrees there are {len(solutions)} solutions, to wit:"
  write(stdout, "    ")
  for i in 0..<len(solutions):
    write(stdout, fmt"{solutions[i]:25}")
    if i mod 3 == 2:
      write(stdout, "\n    ")
  write(stdout, "\n")
echo "\nFor sides in the range [1, 10000] where they cannot ALL be of the same length:\n"
var solutions = solve(60, 10000, false)
echo fmt"    For an angle of 60 degrees there are {len(solutions)} solutions."
