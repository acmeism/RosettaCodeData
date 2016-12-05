import random, rdstdin, strutils

randomize()

let iRange = 1..100

echo "Guess my target number that is between ", iRange.a, " and ", iRange.b, " (inclusive)."
let target = random(iRange)
var answer, i = 0
while answer != target:
  inc i
  let txt = readLineFromStdin("Your guess " & $i & ": ")
  try: answer = parseInt(txt)
  except ValueError:
    echo "  I don't understand your input of '", txt, "'"
    continue
  if answer < iRange.a or answer > iRange.b: echo "  Out of range!"
  elif answer < target: echo "  Too low."
  elif answer > target: echo "  Too high."
  else: echo "  Ye-Haw!!"

echo "Thanks for playing."
