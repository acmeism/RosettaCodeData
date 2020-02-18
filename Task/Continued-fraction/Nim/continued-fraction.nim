proc calc(f: proc(n: int): tuple[a, b: float], n: int): float =
  var a, b, temp = 0.0
  for i in countdown(n, 1):
    (a, b) = f(i)
    temp = b / (a + temp)
  (a, b) = f(0)
  a + temp

proc sqrt2(n: int): tuple[a, b: float] =
  if n > 0:
    (2.0, 1.0)
  else:
    (1.0, 1.0)

proc napier(n: int): tuple[a, b: float] =
  let a = if n > 0: float(n) else: 2.0
  let b = if n > 1: float(n - 1) else: 1.0
  (a, b)

proc pi(n: int): tuple[a, b: float] =
  let a = if n > 0: 6.0 else: 3.0
  let b = (2 * float(n) - 1) * (2 * float(n) - 1)
  (a, b)

echo $calc(sqrt2, 20)
echo $calc(napier, 15)
echo $calc(pi, 10000)
