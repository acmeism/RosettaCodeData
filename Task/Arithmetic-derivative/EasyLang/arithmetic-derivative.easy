func lagarias n .
   if n < 0
      return -lagarias -n
   .
   if n = 0 or n = 1
      return 0
   .
   f = 2
   while n mod f <> 0
      f += 1
   .
   q = n / f
   if q = 1
      return 1
   .
   return q * lagarias f + f * lagarias q
.
for n = -99 to 100
   write lagarias n & " "
.
