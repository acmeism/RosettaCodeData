numfmt 0 6
a1 = 1
a2 = 0
d1 = 3.2
ipow2 = 4
for i = 2 to 13
   a = a1 + (a1 - a2) / d1
   for j = 1 to 10
      x = 0
      y = 0
      for k = 1 to ipow2
         y = 1 - 2 * y * x
         x = a - x * x
      .
      a -= x / y
   .
   d = (a1 - a2) / (a - a1)
   print i & " " & d
   d1 = d ; a2 = a1 ; a1 = a
   ipow2 *= 2
.
