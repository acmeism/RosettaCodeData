fastfunc isprim num .
   if num mod 2 = 0
      if num = 2
         return 1
      .
      return 0
   .
   i = 3
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 2
   .
   return 1
.
base = 4
for p = 2 to 52
   if isprim (base - 1) = 1
      print "2 ^ " & p & " - 1"
   .
   base *= 2
.
