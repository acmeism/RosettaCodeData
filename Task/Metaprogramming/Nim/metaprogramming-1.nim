proc `^`*[T: SomeInteger](base, exp: T): T =
  var (base, exp) = (base, exp)
  result = 1

  while exp != 0:
    if (exp and 1) != 0:
      result *= base
    exp = exp shr 1
    base *= base

echo 2 ^ 10 # 1024
