import sequtils, math

proc prime(a: int): bool =
  if a == 2: return true
  if a < 2 or a mod 2 == 0: return false
  for i in countup(3, sqrt(a.float).int, 2):
    if a mod i == 0:
      return false
  return true

proc prime2(a: int): bool =
  result = not (a < 2 or any(toSeq(2 .. sqrt(a.float).int), a mod it == 0))

proc prime3(a: int): bool =
  if a == 2: return true
  if a < 2 or a mod 2 == 0: return false
  return not any(toSeq countup(3, sqrt(a.float).int, 2), a mod it == 0)

for i in 2..30:
  echo i, " ", prime(i)
