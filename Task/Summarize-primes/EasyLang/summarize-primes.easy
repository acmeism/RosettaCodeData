func prime n .
   if n mod 2 = 0 and n > 2
      return 0
   .
   i = 3
   while i <= sqrt n
      if n mod i = 0
         return 0
      .
      i += 2
   .
   return 1
.
for i = 2 to 999
   if prime i = 1
      ind += 1
      sum += i
      if prime sum = 1
         print ind & ": " & sum
      .
   .
.
