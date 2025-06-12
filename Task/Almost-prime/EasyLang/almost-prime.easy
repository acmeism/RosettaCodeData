func kprime n k .
   i = 2
   while i <= n
      while n mod i = 0
         if f = k : return 0
         f += 1
         n /= i
      .
      i += 1
   .
   if f = k : return 1
   return 0
.
for k = 1 to 5
   write "k=" & k & " : "
   i = 2
   cnt = 0
   while cnt < 10
      if kprime i k = 1
         write i & " "
         cnt += 1
      .
      i += 1
   .
   print ""
.
