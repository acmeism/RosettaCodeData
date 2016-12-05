import tables

let rdecode = {'M': 1000, 'D': 500, 'C': 100, 'L': 50, 'X': 10, 'V': 5, 'I': 1}.toTable

proc decode(roman): int =
  for i in 0 .. <roman.high:
    let (rd, rd1) = (rdecode[roman[i]], rdecode[roman[i+1]])
    result += (if rd < rd1: -rd else: rd)
  result += rdecode[roman[roman.high]]

for r in ["MCMXC", "MMVIII", "MDCLXVI"]:
  echo r, " ", decode(r)
