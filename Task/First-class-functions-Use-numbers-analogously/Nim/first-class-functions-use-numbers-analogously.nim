func multiplier(a, b: float): auto =
  let ab = a * b
  result = func(c: float): float = ab * c

let
  x = 2.0
  xi = 0.5
  y  = 4.0
  yi = 0.25
  z  = x + y
  zi = 1.0 / ( x + y )

let list = [x, y, z]
let invlist = [xi, yi, zi]

for i in 0..list.high:
  # Create a multiplier function...
  let f = multiplier(list[i], invlist[i])
  # ... and apply it.
  echo f(0.5)
