proc lyndonfact s$ .
   n = len s$
   s$[] = strchars s$
   i = 1
   while i <= n
      j = i + 1
      k = i
      while j <= n and strcode s$[k] <= strcode s$[j]
         if strcode s$[k] < strcode s$[j]
            k = i
         else
            k += 1
         .
         j += 1
      .
      while i <= k
         print substr s$ i (j - k)
         i += j - k
      .
   .
.
m$ = "0"
for i to 7
   for c$ in strchars m$
      if c$ = "0"
         m$ &= "1"
      else
         m$ &= "0"
      .
   .
.
lyndonfact m$
