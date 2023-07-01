import macros
macro FizzBuzz(N): untyped =
  var source = ""
  for i in 1..N.intVal:
    source &= "echo \""
    if i mod 15 == 0:
      source &= "FizzBuzz"
    elif i mod 3 == 0:
      source &= "Fizz"
    elif i mod 5 == 0:
      source &= "Buzz"
    else:
      source &= $i
    source &= "\"\n"
  result = parseStmt(source)

FizzBuzz(100)
