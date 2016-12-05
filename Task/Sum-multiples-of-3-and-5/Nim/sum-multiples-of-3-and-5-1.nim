proc sum35(n: int): int =
  for x in 0 .. <n:
    if x mod 3 == 0 or x mod 5 == 0:
      result += x

echo sum35(1000)
