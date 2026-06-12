import strformat

iterator genNumbers(maxOnes: Natural): int =
  var ones = 0
  yield 3
  for _ in 1..maxOnes:
    ones = 10 * ones + 10
    yield ones + 3

for i in genNumbers(7):
  echo &"{i:8} {i*i:18}"
