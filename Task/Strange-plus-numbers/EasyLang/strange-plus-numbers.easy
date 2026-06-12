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
func strange n .
   while n >= 1000
      n = n div 10
   .
   d1 = n mod 10
   n = n div 10
   d2 = n mod 10
   n = n div 10
   d3 = n mod 10
   if isprim (d1 + d2) = 1 and isprim (d2 + d3) = 1
      return 1
   .
   return 0
.
for i = 100 to 499
   if strange i = 1
      write i & " "
   .
.
