import math, strutils

type SDAccum = object
  sdN, sdSum, sdSum2: float

var accum: SDAccum

proc add(accum: var SDAccum; value: float): float =
  # Add a value to the accumulator. Return the standard deviation.
  accum.sdN += 1
  accum.sdSum += value
  accum.sdSum2 += value * value
  result = sqrt(accum.sdSum2 / accum.sdN - accum.sdSum * accum.sdSum / (accum.sdN * accum.sdN))

for value in [float 2, 4, 4, 4, 5, 5, 7, 9]:
  echo value, " ", formatFloat(accum.add(value), precision = -1)
