fastfunc reverse n .
   while n > 0
      r = r * 10 + n mod 10
      n = n div 10
   .
   return r
.
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
while prim < 500
   if isprim reverse prim = 1
      write prim & " "
   .
   prim = nextprim prim
.
