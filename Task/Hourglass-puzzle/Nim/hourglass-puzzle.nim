import math, strutils

func hourglassFlipper(hourglasses: openArray[int];
                      target: int): tuple[start: int; series: seq[int]] =
  var flippers = @hourglasses
  for _ in 0..10_000:
    let n = min(flippers)
    result.series.add n
    for i in 0..flippers.high:
      dec flippers[i], n
      if flippers[i] == 0: flippers[i] = hourglasses[i]
    result.start = result.series.high
    while result.start >= 0:
      if sum(result.series[result.start..^1]) == target: return
      dec result.start
  raise newException(ValueError, "Unable to find an answer within 10_000 iterations.")


echo "Flip an hourglass every time it runs out of grains, "
echo "and note the interval in time."
const Tests = [(@[4, 7], 9), (@[5, 7, 31], 36)]
for test in Tests:
  let
    hourglasses = test[0]
    target = test[1]
    (start, series) = hourglassFlipper(hourglasses, target)
    `end` = series.high
  echo "\nSeries: ", series.join(" ")
  echo "Use hourglasses from indices $1 to $2 (inclusive) to sum ".format(start, `end`),
       "$1 using $2.".format(target, hourglasses.join(" "))
