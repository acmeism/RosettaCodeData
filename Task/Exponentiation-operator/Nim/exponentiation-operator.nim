proc `^`[T: float|int](base: T; exp: int): T =
  var (base, exp) = (base, exp)
  result = 1

  if exp < 0:
    when T is int:
      if base * base != 1: return 0
      elif (exp and 1) == 0: return 1
      else: return base
    else:
      base = 1.0 / base
      exp = -exp

  while exp != 0:
    if (exp and 1) != 0:
      result *= base
    exp = exp shr 1
    base *= base

echo "2^6 = ", 2^6
echo "2^-6 = ", 2 ^ -6
echo "2.71^6 = ", 2.71^6
echo "2.71^-6 = ", 2.71 ^ -6
