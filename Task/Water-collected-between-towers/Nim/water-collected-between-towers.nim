import math, sequtils, sugar

proc water(barChart: seq[int], isLeftPeak = false, isRightPeak = false): int =
  if len(barChart) <= 2:
    return
  if isLeftPeak and isRightPeak:
    return sum(barChart[1..^2].map(x=>min(barChart[0], barChart[^1])-x))
  var i: int
  if isLeftPeak:
    i = maxIndex(barChart[1..^1])+1
  else:
    i = maxIndex(barChart[0..^2])
  return water(barChart[0..i], isLeftPeak, true)+water(barChart[i..^1], true, isRightPeak)

const barCharts = [
    @[1, 5, 3, 7, 2],
    @[5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
    @[2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
    @[5, 5, 5, 5],
    @[5, 6, 7, 8],
    @[8, 7, 7, 6],
    @[6, 7, 10, 7, 6]]
const waterUnits = barCharts.map(chart=>water(chart, false, false))
echo(waterUnits)
