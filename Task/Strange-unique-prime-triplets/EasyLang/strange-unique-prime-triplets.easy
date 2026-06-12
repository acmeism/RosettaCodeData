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
lim = 29
for n = 1 to lim
   for m = n + 1 to lim
      for p = m + 1 to lim
         sum = n + m + p
         if isprim sum = 1 and isprim n = 1 and isprim m = 1 and isprim p = 1
            write "(" & n & " " & m & " " & p & ") "
         .
      .
   .
.
