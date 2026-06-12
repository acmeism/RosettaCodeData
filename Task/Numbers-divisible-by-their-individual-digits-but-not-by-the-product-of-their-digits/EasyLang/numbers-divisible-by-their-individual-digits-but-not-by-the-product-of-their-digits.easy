func divisible n .
   p = 1
   c = n
   while c > 0
      d = c mod 10
      if d = 0 or n mod d <> 0
         return 0
      .
      p *= d
      c = c div 10
   .
   return if n mod p > 0
.
for n = 1 to 999
   if divisible n = 1
      write n & " "
   .
.
