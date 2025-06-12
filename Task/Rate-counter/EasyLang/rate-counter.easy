fastfunc isprim num .
   if num mod 2 = 0 and num > 2 : return 0
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
for i to 5
   t0 = systime
   h = isprim 9005099254741061
   h = h
   print (systime - t0) * 1000 & " ms"
.
