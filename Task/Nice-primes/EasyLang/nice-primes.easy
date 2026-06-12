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
func digroot n .
   return 1 + (n - 1) mod 9
.
for n = 501 to 999
   if isprim digroot n = 1 and isprim n = 1
      write n & " "
   .
.
