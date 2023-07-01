import strformat

type Digit = range[0..15]

iterator digits(n: int64): Digit =
  var n = n
  while true:
    yield n and 15
    n = n shr 4
    if n == 0: break

func isLynchBell(num: int64): bool =
  var hSet: set[Digit]
  for d in num.digits:
    if d == 0 or num mod d != 0 or d in hSet:
      return false
    hSet.incl(d)
  return true

const Magic = 15 * 14 * 13 * 12 * 11
const High = 0xfedcba987654321 div Magic * Magic

for n in countdown(High, Magic, Magic):
  if n.isLynchBell:
    echo &"{n:x}"
    break
