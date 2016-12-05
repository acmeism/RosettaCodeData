import math, rdstdin, strutils, algorithm

proc f(x): float = x.abs.pow(0.5) + 5 * x.pow(3)

proc ask: seq[float] =
  readLineFromStdin("\n11 numbers: ").strip.split[0..10].map(parseFloat)

var s = ask()
reverse s
for x in s:
  let result = f x
  stdout.write " ",x,":", if result > 400: "TOO LARGE!" else: $result
echo ""
