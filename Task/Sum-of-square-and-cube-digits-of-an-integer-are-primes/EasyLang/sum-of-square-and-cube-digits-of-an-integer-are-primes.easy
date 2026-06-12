fastfunc digsum h .
   while h > 0
      sum += h mod 10
      h = h div 10
   .
   return sum
.
fastfunc isprim num .
   if num < 2
      return 0
   .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
for i = 1 to 99
   if isprim digsum (i * i) = 1 and isprim digsum (i * i * i) = 1
      write i & " "
   .
.
