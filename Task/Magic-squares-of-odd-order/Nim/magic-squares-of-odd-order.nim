import strutils

proc magic(n: int) =
  let length = len($(n * n))
  for row in 1 .. n:
    for col in 1 .. n:
      let cell = (n * ((row + col - 1 + n div 2) mod n) +
                  ((row + 2 * col - 2) mod n) + 1)
      stdout.write ($cell).align(length), ' '
    echo ""
  echo "\nAll sum to magic number ", (n * n + 1) * n div 2

for n in [3, 5, 7]:
  echo "\nOrder ", n, "\n======="
  magic(n)
