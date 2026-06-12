fastfunc rev n .
   while n > 0
      r = r * 10 + n mod 10
      n = n div 10
   .
   return r
.
for i = 100 to 999
   for j = i to 999
      p = i * j
      if p > max and p = rev p
         max = p
      .
   .
.
print max
