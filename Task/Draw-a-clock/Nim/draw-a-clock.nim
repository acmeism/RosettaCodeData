import times, os

const
  t = ["⡎⢉⢵","⠀⢺⠀","⠊⠉⡱","⠊⣉⡱","⢀⠔⡇","⣏⣉⡉","⣎⣉⡁","⠊⢉⠝","⢎⣉⡱","⡎⠉⢱","⠀⠶⠀"]
  b = ["⢗⣁⡸","⢀⣸⣀","⣔⣉⣀","⢄⣀⡸","⠉⠉⡏","⢄⣀⡸","⢇⣀⡸","⢰⠁⠀","⢇⣀⡸","⢈⣉⡹","⠀⠶ "]

while true:
  let x = getClockStr()
  stdout.write "\e[H\e[J"
  for c in x: stdout.write t[c.ord - '0'.ord]
  echo ""
  for c in x: stdout.write b[c.ord - '0'.ord]
  echo ""
  sleep 1000
