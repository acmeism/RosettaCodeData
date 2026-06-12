func oddsemi n .
   i = 3
   while i <= sqrt n
      while n mod i = 0
         count += 1
         if count > 1
            return 0
         .
         n = n div i
      .
      i += 2
   .
   return if count = 1
.
for i = 1 step 2 to 999
   if oddsemi i = 1
      write i & " "
   .
.
