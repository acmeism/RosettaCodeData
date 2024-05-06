func cntdiv n .
   i = 1
   while i <= sqrt n
      if n mod i = 0
         cnt += 1
         if i <> sqrt n
            cnt += 1
         .
      .
      i += 1
   .
   return cnt
.
len seq[] 15
i = 1
while n < 15
   k = cntdiv i
   if k <= 15 and seq[k] = 0
      seq[k] = i
      n += 1
   .
   i += 1
.
for v in seq[]
   print v
.
