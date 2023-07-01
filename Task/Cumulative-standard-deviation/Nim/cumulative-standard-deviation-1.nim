import math, strutils

var sdSum, sdSum2, sdN = 0.0

proc sd(x: float): float =
  sdN += 1
  sdSum += x
  sdSum2 += x * x
  sqrt(sdSum2 / sdN - sdSum * sdSum / (sdN * sdN))

for value in [float 2,4,4,4,5,5,7,9]:
  echo value, " ", formatFloat(sd(value), precision = -1)
