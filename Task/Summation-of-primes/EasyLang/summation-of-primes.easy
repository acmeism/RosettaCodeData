fastfunc isprim num .
   i = 3
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 2
   .
   return 1
.
fastfunc nextprim prim .
   repeat
      prim += 2
      until isprim prim = 1
   .
   return prim
.
sum = 2
prim = 3
repeat
   sum += prim
   prim = nextprim prim
   until prim >= 2000000
.
print sum
