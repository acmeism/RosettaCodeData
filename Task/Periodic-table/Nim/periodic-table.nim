import std/strformat

const Limits = [3..10, 11..18, 19..36, 37..54, 55..86, 87..118]

func periodicTable(n: Positive): (int, int) =
  doAssert n in 1..118, "Atomic number is out of range."
  if n == 1: return (1, 1)
  if n == 2: return (1, 18)
  if n in 57..71: return (8, n - 53)
  if n in 89..103: return (9, n - 85)
  var row, start, stop = 0
  for i, limit in Limits:
    if n in limit:
      row = i + 2
      start = limit.a
      stop = limit.b
      break
  if n < start + 2 or row == 4 or row == 5:
    return (row, n - start + 1)
  result = (row, n - stop + 18)

for n in [1, 2, 29, 42, 57, 58, 59, 71, 72, 89, 90, 103, 113]:
  let (row, col) = periodicTable(n)
  echo &"Atomic number {n:3} → {row}, {col}"
