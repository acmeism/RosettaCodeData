from strutils import parseFloat, formatFloat, ffDecimal

proc aplusb(a,b: float): float =
  return a + b

proc getnumber(): float =
  try:
    parseFloat(readLine(stdin))
  except ValueError:
    echo("Please enter a number: ")
    getnumber()

echo("First number please: ")
let first: float = getnumber()

echo("Second number please: ")
let second: float = getnumber()

echo("Result: " & formatFloat(aplusb(first, second), ffDecimal, 2))
