import sugar

proc a(k: int; x1, x2, x3, x4, x5: proc(): int): int =
  var k = k
  proc b(): int =
    dec k
    a(k, b, x1, x2, x3, x4)
  if k <= 0: x4() + x5()
  else: b()

echo a(10, () => 1, () => -1, () => -1, () => 1, () => 0)
