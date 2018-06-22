proc factorial(x): int =
  if x > 0: x * factorial(x - 1)
  else: 1
