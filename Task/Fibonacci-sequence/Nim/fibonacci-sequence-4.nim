proc Fibonacci(n: int, current: int64, next: int64): int64 =
  if n == 0:
    result = current
  else:
    result = Fibonacci(n - 1, next, current + next)
proc Fibonacci(n: int): int64 =
  result = Fibonacci(n, 0, 1)
