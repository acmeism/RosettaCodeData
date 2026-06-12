func strange n .
   dig = n mod 10
   n = n div 10
   while n > 0
      digp = dig
      dig = n mod 10
      n = n div 10
      d = abs (dig - digp)
      if d <> 2 and d <> 3 and d <> 5 and d <> 7
         return 0
      .
   .
   return 1
.
for i = 100 to 499
   if strange i = 1
      write i & " "
   .
.
