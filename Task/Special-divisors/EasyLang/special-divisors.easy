func reverse s .
   while s > 0
      e = e * 10 + s mod 10
      s = s div 10
   .
   return e
.
for n = 1 to 199
   u = reverse n
   for d = 1 to n - 1
      if n mod d = 0
         b = reverse d
         if u mod b <> 0
            break 1
         .
      .
   .
   if d = n
      write n & " "
   .
.
