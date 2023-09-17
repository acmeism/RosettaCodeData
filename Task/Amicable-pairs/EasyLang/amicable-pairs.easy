func sumdivs n .
   sum = 1
   for d = 2 to sqrt n
      if n mod d = 0
         sum += d + n div d
      .
   .
   return sum
.
for n = 1 to 20000
   m = sumdivs n
   if m > n
      if sumdivs m = n
         print n & " " & m
      .
   .
.
