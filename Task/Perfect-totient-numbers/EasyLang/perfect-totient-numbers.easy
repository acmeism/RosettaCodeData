func totient n .
   tot = n
   i = 2
   while i <= sqrt n
      if n mod i = 0
         while n mod i = 0
            n = n div i
         .
         tot -= tot div i
      .
      if i = 2
         i = 1
      .
      i += 2
   .
   if n > 1
      tot -= tot div n
   .
   return tot
.
n = 1
while cnt < 20
   tot = n
   sum = 0
   while tot <> 1
      tot = totient tot
      sum += tot
   .
   if sum = n
      write n & " "
      cnt += 1
   .
   n += 2
.
