import math
import strformat

func f(x: float): float = x ^ 3 - 3 * x ^ 2 + 2 * x

var
  step = 0.01
  start = -1.0
  stop = 3.0
  sign = f(start) > 0
  x = start

while x <= stop:
  var value = f(x)

  if value == 0:
    echo fmt"Root found at {x:.5f}"
  elif (value > 0) != sign:
    echo fmt"Root found near {x:.5f}"

  sign = value > 0
  x += step
