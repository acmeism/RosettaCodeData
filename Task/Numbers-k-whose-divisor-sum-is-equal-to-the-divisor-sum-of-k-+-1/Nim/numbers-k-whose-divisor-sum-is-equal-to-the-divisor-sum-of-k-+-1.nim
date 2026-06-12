from math import sum, sqrt

proc getDivisorSum(n: Natural): Natural =
  for i in 1..int(sqrt(float(n))) + 1:
    if n mod i == 0:
      result += i
      if i != n div i:
        result += n div i

var
  answers: seq[Natural]
  n = 1

while answers.len < 50:
  if n.getDivisorSum == (n + 1).getDivisorSum:
    answers &= n
  n += 1

for i in 1..answers.len:
  echo i, ": ", answers[i - 1]

