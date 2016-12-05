import strutils

proc binomial(m, n): auto =
  result = 1
  var
    d = m - n
    n = n
    m = m
  if d > n:
    n = d

  while m > n:
    result *= m
    dec m
    while d > 1 and (result mod d) == 0:
      result = result div d
      dec d

proc catalan1(n): auto =
  binomial(2 * n, n) div (n + 1)

proc catalan2(n): auto =
  if n == 0:
    result = 1
  for i in 0 .. <n:
    result += catalan2(i) * catalan2(n - 1 - i)

proc catalan3(n): int =
  if n > 0: 2 * (2 * n - 1) * catalan3(n - 1) div (1 + n)
  else: 1

for i in 0..15:
  echo align($i, 7), " ", align($catalan1(i), 7), " ", align($catalan2(i), 7), " ", align($catalan3(i), 7)
