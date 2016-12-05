import strutils

proc `^`*(base: int, exp: int): int =
  var (base, exp) = (base, exp)
  result = 1

  while exp != 0:
    if (exp and 1) != 0:
      result *= base
    exp = exp shr 1
    base *= base

proc magic(n) =
  for row in 1 .. n:
    for col in 1 .. n:
      let cell = (n * ((row + col - 1 + n div 2) mod n) +
                  ((row + 2 * col - 2) mod n) + 1)
      stdout.write align($cell, len($(n^2)))," "
    echo ""
  echo "\nAll sum to magic number ", ((n * n + 1) * n div 2)

for n in [5, 3, 7]:
  echo "\nOrder ",n,"\n======="
  magic(n)
