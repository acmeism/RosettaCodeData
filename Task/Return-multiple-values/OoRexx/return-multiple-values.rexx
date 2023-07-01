r = addsub(3, 4)
say r[1] r[2]

::routine addsub
  use arg x, y
  return .array~of(x + y, x - y)
