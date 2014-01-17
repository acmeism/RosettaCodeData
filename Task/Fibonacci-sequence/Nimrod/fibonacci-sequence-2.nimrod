proc Fibonacci(n: int): int =
  var
    first = 0
    second = 1

  for i in 0 .. <n:
    swap first, second
    second += first

  result = first
