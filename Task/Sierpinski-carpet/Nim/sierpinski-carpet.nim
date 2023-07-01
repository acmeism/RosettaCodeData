import math

proc inCarpet(x, y: int): bool =
  var x = x
  var y = y
  while true:
    if x == 0 or y == 0:
      return true
    if x mod 3 == 1 and y mod 3 == 1:
      return false
    x = x div 3
    y = y div 3

proc carpet(n: int) =
  for i in 0 ..< 3^n:
    for j in 0 ..< 3^n:
      stdout.write if inCarpet(i, j): "* " else: "  "
    echo()

carpet(3)
