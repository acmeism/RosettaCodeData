fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
prim = 2
proc nextprim .
   repeat
      prim += 1
      until isprim prim = 1
   .
.
while cnt < 30
   n += prim
   if isprim n = 1
      cnt += 1
      write n & " "
   .
   nextprim
.
