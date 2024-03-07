func karp n .
   h = n * n
   e = 1
   while h > 0
      t += h mod 10 * e
      e = e * 10
      h = h div 10
      if t > 0 and h + t = n
         return 1
      .
   .
.
for i to 9999
   if karp i = 1
      write i & " "
   .
.
