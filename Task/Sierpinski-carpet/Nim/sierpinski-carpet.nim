proc `^`*(base: int, exp: int): int =
  var (base, exp) = (base, exp)
  result = 1

  while exp != 0:
    if (exp and 1) != 0:
      result *= base
    exp = exp shr 1
    base *= base

proc inCarpet(x, y): bool =
  var x = x
  var y = y
  while true:
    if x == 0 or y == 0:
      return true
    if x mod 3 == 1 and y mod 3 == 1:
      return false

    x = x div 3
    y = y div 3

proc carpet(n) =
  for i in 0 .. <(3^n):
    for j in 0 .. <(3^n):
      if inCarpet(i, j):
        stdout.write "* "
      else:
        stdout.write "  "
    echo ""

carpet(3)
