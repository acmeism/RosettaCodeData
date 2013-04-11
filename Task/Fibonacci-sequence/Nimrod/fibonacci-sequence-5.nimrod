iterator fib: int {.closure.} =
  var a = 0
  var b = 1
  while true:
    yield a
    swap a, b
    b = a + b

var f = fib
for i in 0.. <10:
  echo f()
