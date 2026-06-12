import math

proc isPrime(n: Natural): bool =
  if n < 2:
    return false
  elif n == 2:
    return true
  else:
    for i in 2..int(sqrt(float(n))) + 1:
      if n mod i == 0:
        return false
    return true

when isMainModule:
  var
    n = 600851475143
    j = 3
  while not isPrime(n):
    if n mod j == 0:
      n = int(n / j)
    j += 2
  echo n
