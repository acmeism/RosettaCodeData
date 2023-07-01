type Digit = range[0..9]

iterator digits(n: int64): Digit =
  var n = n
  while true:
    yield n mod 10
    n = n div 10
    if n == 0: break

func isLynchBell(num: int64): bool =
  var hSet: set[Digit]
  for d in num.digits:
    if d == 0 or num mod d != 0 or d in hSet:
      return false
    hSet.incl(d)
  return true

const
  Magic = 9 * 8 * 7
  High = 0x9876432 div Magic * Magic

for n in countdown(High, Magic, Magic):
  if n.isLynchBell:
    echo n
    break
