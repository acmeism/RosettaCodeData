fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
write 2 & " "
p = 2
j = 1
repeat
   while isprim (p + j * j) = 0
      j += 1
   .
   p += j * j
   until p > 16000
   write p & " "
   j = 1
.
