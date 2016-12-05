proc Fibonacci(n: int): int64 =
  if n <= 2:
    result = 1
  else:
    result = Fibonacci(n - 1) + Fibonacci(n - 2)
