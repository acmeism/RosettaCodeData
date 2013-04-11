import strutils, os
var sum = 0
for i in countup(1, paramCount()):
  sum = sum + parseInt(paramStr(i))
echo sum
