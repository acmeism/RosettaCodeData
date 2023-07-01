import strutils
import math

proc is_disarium(num: int): bool =
  let n = intToStr(num)
  var sum = 0
  for i in 0..len(n)-1:
    sum += int((int(n[i])-48) ^ (i+1))
  return sum == num

var i = 0
var count = 0
while count < 19:
  if is_disarium(i):
    stdout.write i, " "
    count += 1
  i += 1
echo ""
