func digprimsum13 n .
   while n > 0
      d = n mod 10
      if d < 2 or d = 4 or d = 6 or d >= 8
         return 0
      .
      sum += d
      n = n div 10
   .
   return if sum = 13
.
p = 2
while p <= 322222
   if digprimsum13 p = 1
      write p & " "
   .
   p += 1
.
