proc m(n: int): int

proc f(n: int): int =
  if n == 0: 1
  else: n - m(f(n-1))

proc m(n: int): int =
  if n == 0: 0
  else: n - f(m(n-1))

for i in 1 .. 10:
  echo f(i)
  echo m(i)
