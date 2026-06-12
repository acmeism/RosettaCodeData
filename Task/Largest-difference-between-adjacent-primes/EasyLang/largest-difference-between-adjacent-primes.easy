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
prim = 2
repeat
   prev = prim
   prim = nextprim prim
   until prim > 1e6
   max = higher max (prim - prev)
.
print max
