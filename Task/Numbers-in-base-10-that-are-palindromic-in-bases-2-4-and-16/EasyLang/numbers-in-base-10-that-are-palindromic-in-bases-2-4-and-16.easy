func rev n base .
   while n > 0
      r = r * base + n mod base
      n = n div base
   .
   return r
.
for i = 0 to 25000 - 1
   if rev i 2 = i and rev i 4 = i and rev i 16 = i
      write i & " "
   .
.
