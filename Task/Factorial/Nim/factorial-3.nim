proc factorial(x: int): int =
  result = 1
  for i in 2..x:
    result *= i
