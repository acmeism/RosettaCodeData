proc mkspiral n &t[] .
   subr side
      for i to l
         ind += d
         t[ind] = cnt
         cnt += 1
      .
   .
   len t[] n * n
   l = n
   while cnt < len t[]
      d = 1
      side
      l -= 1
      d = n
      side
      d = -1
      side
      l -= 1
      d = -n
      side
   .
.
n = 5
mkspiral n t[]
numfmt 3 0
for i to n * n
   write t[i]
   if i mod n = 0 : print ""
.
