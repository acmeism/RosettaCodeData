import math, rdstdin, strutils, algorithm, sequtils

proc f(x: float): float = x.abs.pow(0.5) + 5 * x.pow(3)

proc ask: seq[float] =
  readLineFromStdin("11 numbers: ").strip.split[0..10].map(parseFloat)

var s = ask()
reverse s
for x in s:
  let result = f(x)
  echo x, ": ", if result > 400: "TOO LARGE!" else: $result
