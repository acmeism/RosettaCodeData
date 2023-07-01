import math

for i in 1..<5000:
  var sum: int64 = 0
  var number = i
  while number > 0:
    var digit = number mod 10
    sum += digit ^ digit
    number = number div 10
  if sum == i:
    echo i
