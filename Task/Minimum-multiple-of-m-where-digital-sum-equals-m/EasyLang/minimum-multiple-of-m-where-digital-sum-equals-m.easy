fastfunc f n .
   m = 1
   repeat
      h = m * n
      sum = 0
      while h > 0
         sum += h mod 10
         h = h div 10
      .
      until sum = n
      m += 1
   .
   return m
.
for n = 1 to 70
   write f n & " "
.
