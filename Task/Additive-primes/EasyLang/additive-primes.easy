func prime n .
   if n mod 2 = 0 and n > 2 : return 0
   i = 3
   sq = sqrt n
   while i <= sq
      if n mod i = 0 : return 0
      i += 2
   .
   return 1
.
func digsum n .
   while n > 0
      sum += n mod 10
      n = n div 10
   .
   return sum
.
for i = 2 to 500
   if prime i = 1
      s = digsum i
      if prime s = 1 : write i & " "
   .
.
