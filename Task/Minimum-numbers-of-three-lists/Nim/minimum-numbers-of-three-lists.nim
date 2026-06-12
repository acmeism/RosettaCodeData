const
  Numbers1 = [ 5, 45, 23, 21, 67]
  Numbers2 = [43, 22, 78, 46, 38]
  Numbers3 = [ 9, 98, 12, 98, 53]

var numbers: array[0..Numbers1.high, int]

for i in 0..numbers.high:
  numbers[i] = min(min(Numbers1[i], Numbers2[i]), Numbers3[i])

echo numbers
