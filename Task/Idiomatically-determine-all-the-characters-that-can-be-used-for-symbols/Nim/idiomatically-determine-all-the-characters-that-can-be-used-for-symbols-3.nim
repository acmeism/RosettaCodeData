var `const`= 3
echo `const`

proc `<`(a, b: int): bool =
  echo a, " ", b
  system.`<`(a, b)

echo 4 < 7

proc `Π`(a: varargs[int]): int =
  result = 1
  for n in a: result *= n

echo Π(4, 5, 7)

var `1` = 2
echo `1`
