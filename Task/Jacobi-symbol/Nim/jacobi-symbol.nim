template isOdd(n: int): bool = (n and 1) != 0
template isEven(n: int): bool = (n and 1) == 0


func jacobi(n, k: int): range[-1..1] =
  assert k > 0 and k.isOdd
  var n = n mod k
  var k = k
  result = 1
  while n != 0:
    while n.isEven:
      n = n shr 1
      if (k and 7) in [3, 5]:
        result = -result
    swap n, k
    if (n and 3) == 3 and (k and 3) == 3:
      result = -result
    n = n mod k
  if k != 1: result = 0

when isMainModule:

  import strutils

  stdout.write "n/k|"
  for n in 1..20:
    stdout.write align($n, 3)
  echo '\n' & repeat("—", 64)

  for k in countup(1, 21, 2):
    stdout.write align($k, 2), " |"
    for n in 1..20:
      stdout.write align($jacobi(n, k), 3)
    echo ""
