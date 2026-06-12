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
func dig123 n .
   while n > 0
      if n mod 1000 = 123
         return 1
      .
      n = n div 10
   .
   return 0
.
prim = 2
repeat
   if dig123 prim = 1
      write prim & " "
   .
   prim = nextprim prim
   until prim >= 100000
.
