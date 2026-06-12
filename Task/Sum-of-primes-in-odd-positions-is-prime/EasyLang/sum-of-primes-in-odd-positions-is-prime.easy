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
for p = 2 to 999
   if isprim p = 1
      idx += 1
      if idx mod 2 <> 0
         s += p
         if isprim s = 1
            write "(" & idx & " " & p & " " & s & ") "
         .
      .
   .
.
