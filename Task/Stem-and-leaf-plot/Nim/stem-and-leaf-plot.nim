import tables
import math
import strutils
import algorithm

type
  StemLeafPlot = ref object
    leafDigits: int
    multiplier: int
    plot: TableRef[int, seq[int]]

proc `$`(s: seq[int]): string =
  result = ""
  for item in s:
    result &= $item & " "

proc `$`(self: StemLeafPlot): string =
  result = ""
  var keys: seq[int] = @[]
  for stem, _ in self.plot:
    keys.add(stem)
  for printedStem in keys.min..keys.max:
    result &= align($printedStem & " | ", ($keys.max).len + 4)
    if printedStem in keys:
      self.plot[printedStem].sort(system.cmp[int])
      result &= $self.plot[printedStem]
    result &= "\n"

proc parse(self: StemLeafPlot, value: int): tuple[stem, leaf: int] =
  (value div self.multiplier, abs(value mod self.multiplier))

proc init[T](self: StemLeafPlot, leafDigits: int, data: openArray[T]) =
  self.leafDigits = leafDigits
  self.multiplier = 10 ^ leafDigits
  self.plot = newTable[int, seq[int]]()
  for value in data:
    let (stem, leaf) = self.parse(value)
    if stem notin self.plot:
      self.plot[stem] = @[leaf]
    else:
      self.plot[stem].add(leaf)

var taskData = @[12, 127,  28,  42,  39, 113,  42,  18,  44, 118,  44,  37, 113, 124,
                 37,  48, 127,  36,  29,  31, 125, 139, 131, 115, 105, 132, 104, 123,
                 35, 113, 122,  42, 117, 119,  58, 109,  23, 105,  63,  27,  44, 105,
                 99,  41, 128, 121, 116, 125,  32,  61,  37, 127,  29, 113, 121,  58,
                 114, 126,  53, 114,  96,  25, 109,   7,  31, 141,  46,  13,  27,  43,
                 117, 116,  27,   7,  68,  40,  31, 115, 124,  42, 128,  52,  71, 118,
                 117,  38,  27, 106,  33, 117, 116, 111,  40, 119,  47, 105,  57, 122,
                 109, 124, 115,  43, 120,  43,  27,  27,  18,  28,  48, 125, 107, 114,
                 34, 133,  45, 120,  30, 127,  31, 116, 146]

var negativeData = @[-24, -12, -3, 4, 6, 6, 17, 25, 57]

echo "Using the Task's Test Data"
var taskPlot = StemLeafPlot()
taskPlot.init(1, taskData)
echo $taskPlot

echo "Test with Negative Stem"
var negativePlot = StemLeafPlot()
negativePlot.init(1, negativeData)
echo $negativePlot
