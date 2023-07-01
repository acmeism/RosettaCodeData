import math, strutils

func accumBuilder(): auto =
  var sdSum, sdSum2, sdN = 0.0

  result = func(value: float): float =
    sdN += 1
    sdSum += value
    sdSum2 += value * value
    result = sqrt(sdSum2 / sdN - sdSum * sdSum / (sdN * sdN))

let std = accumBuilder()

for value in [float 2, 4, 4, 4, 5, 5, 7, 9]:
  echo value, " ", formatFloat(std(value), precision = -1)
