from strutils import parseInt

proc ackermann(m, n: int64): int64 =
  if m == 0:
    result = n + 1
  elif n == 0:
    result = ackermann(m - 1, 1)
  else:
    result = ackermann(m - 1, ackermann(m, n - 1))

proc getNumber(): int =
  try:
    result = stdin.readLine.parseInt
  except ValueError:
    echo "An integer, please!"
    result = getNumber()
  if result < 0:
    echo "Please Enter a non-negative Integer: "
    result = getNumber()

echo "First non-negative Integer please: "
let first = getNumber()
echo "Second non-negative Integer please: "
let second = getNumber()
echo "Reslut: ", $ackermann(first, second)
