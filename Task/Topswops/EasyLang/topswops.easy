global n d best[] .
#
proc tryswaps &a[] f .
   if d > best[n] : best[n] = d
   for s = len a[] downto 1
      if a[s] = 0 or a[s] = s : break 1
      if d + best[s] <= best[n] : return
   .
   d += 1
   for i = 1 to s : b[] &= a[i]
   k = 1
   for i = 2 to s
      k *= 2
      if b[i] = 0 and bitand f k = 0 or b[i] = i
         b[1] = i
         for j = i - 1 downto 1
            b[i - j + 1] = a[j]
         .
         tryswaps b[] (bitor f k)
      .
   .
   d -= 1
.
for n = 1 to 10
   best[] &= 0
   x[] &= 0
   d = 0
   tryswaps x[] 1
   print n & ": " & best[n]
.
