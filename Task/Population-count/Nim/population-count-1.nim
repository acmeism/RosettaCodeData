import bitops
import strformat

var n = 1
write(stdout, "3^x   :")
for i in 0..<30:
  write(stdout, fmt"{popcount(n):2} ")
  n *= 3

var od: array[30, int]
var ne, no = 0
n = 0
write(stdout, "\nevil  :")
while ne + no < 60:
  if (popcount(n) and 1) == 0:
    if ne < 30:
      write(stdout, fmt"{n:2} ")
      inc ne
  else:
    if no < 30:
      od[no] = n
      inc no
  inc n

write(stdout, "\nodious:")
for i in 0..<30:
  write(stdout, fmt"{od[i]:2} ")
write(stdout, '\n')
