proc Fibonacci(n: int): int64 =
  var first: int64 = 0
  var second: int64 = 1
  var t: int64 = 0
  while n > 1:
    t = first + second
    first = second
    second = t
    dec(n)
  result = second
