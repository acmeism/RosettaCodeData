# Using scoped function fibI inside fib
proc fib(x: int): int =
  proc fibI(n: int): int =
    if n < 2: n else: fibI(n-2) + fibI(n-1)
  if x < 0:
    raise newException(ValueError, "Invalid argument")
  return fibI(x)

for i in 0..4:
  echo fib(i)

# fibI(10) # undeclared identifier 'fibI'
