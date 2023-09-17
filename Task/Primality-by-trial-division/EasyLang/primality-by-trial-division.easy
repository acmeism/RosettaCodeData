func isprim n .
   if n < 2
      return 0
   .
   if n mod 2 = 0 and n > 2
      return 0
   .
   i = 3
   sq = sqrt n
   while i <= sq
      if n mod i = 0
         return 0
      .
      i += 2
   .
   return 1
.
print isprim 1995937
