from strutils import parseInt

proc ackermann(m,n: int): int =
  var res: int
  if m == 0:
    res += n + 1
  elif m > 0 and n == 0:
    res += ackermann(m-1, 1)
  elif m > 0 and n > 0:
    res += ackermann(m-1, ackermann(m, n-1))
  return res

proc getnumber(): int =
  try:
    parseInt(readLine(stdin))
  except EInvalidValue:
    echo("Please enter an integer: ")
    getnumber()

echo("First number please: ")
var first: int = getnumber()
while first < 0:
  echo("Please enter a non-negative integer value.")
  first = getnumber()

echo("Second number please: ")
var second: int = getnumber()
while second < 0:
  echo("Please enter a non-negative integer value.")
  second = getnumber()

echo("Result: " & $ackermann(first, second))
