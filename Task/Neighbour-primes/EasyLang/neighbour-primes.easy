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
fastfunc nextprim prim .
   repeat
      prim += 1
      until isprim prim = 1
   .
   return prim
.
q = 2
repeat
   p = q
   until p >= 500
   q = nextprim q
   if isprim (2 + p * q) = 1
      write p & " "
   .
.
