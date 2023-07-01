import std/[unicode, strformat]

func sudan(n, x, y: Natural): int =
  if n == 0: return x + y
  if y == 0: return x
  let z = sudan(n, x, y - 1)
  return sudan(n - 1, z, z + y)

const Delta = ord("₀".toRunes()[0]) - ord('0')

func subscript(n: Natural): string =
  for c in $n:
    result.add Rune(ord(c) + Delta)

for (n, x, y) in [(0, 0, 0), (1, 1, 1), (2, 1, 1), (2, 2, 1), (2, 2, 2), (3, 1, 1)]:
  echo &"F{subscript(n)}({x}, {y}) = {sudan(n, x, y)}"
