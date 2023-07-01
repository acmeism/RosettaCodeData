import random, strutils

randomize()

let iRange = 1..100

echo "Guess my target number that is between ", iRange.a, " and ", iRange.b, " (inclusive)."
let target = rand(iRange)
var answer, i = 0
while answer != target:
  inc i
  stdout.write "Your guess ", i, ": "
  let txt = stdin.readLine()
  try: answer = parseInt(txt)
  except ValueError:
    echo "  I don't understand your input of '", txt, "'"
    continue
  if answer notin iRange: echo "  Out of range!"
  elif answer < target: echo "  Too low."
  elif answer > target: echo "  Too high."
  else: echo "  Ye-Haw!!"

echo "Thanks for playing."
