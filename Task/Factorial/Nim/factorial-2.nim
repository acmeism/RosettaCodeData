proc factorial(x): int =
  result = 1
  for i in 1..x+1:
    result *= i
