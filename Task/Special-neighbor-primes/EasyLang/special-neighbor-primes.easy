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
p = 2
for i = 3 step 2 to 99
   if isprim i = 1
      pp = p
      p = i
      if isprim (pp + p - 1) = 1
         write "(" & pp & " " & p & ") "
      .
   .
.
