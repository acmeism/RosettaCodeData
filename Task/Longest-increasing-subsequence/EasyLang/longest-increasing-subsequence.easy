func[] lis x[] .
   n = len x[]
   len p[] n
   len m[] n
   for i to n
      lo = 1
      hi = lng
      while lo <= hi
         mid = (lo + hi) div 2
         if x[m[mid]] < x[i]
            lo = mid + 1
         else
            hi = mid - 1
         .
      .
      if lo > 1
         p[i] = m[lo - 1]
      .
      m[lo] = i
      if lo > lng
         lng = lo
      .
   .
   len res[] lng
   if lng > 0
      k = m[lng]
      for i = lng downto 1
         res[i] = x[k]
         k = p[k]
      .
   .
   return res[]
.
tests[][] = [ [ 3 2 6 4 5 1 ] [ 0 8 4 12 2 10 6 14 1 9 5 13 3 11 7 15 ]  ]
for x to len tests[][]
   print lis tests[x][]
.
