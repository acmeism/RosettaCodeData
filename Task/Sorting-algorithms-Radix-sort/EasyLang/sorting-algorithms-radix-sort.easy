proc sort &d[] .
   # radix = 10
   radix = 256
   max = -1 / 0
   for di = 1 to len d[]
      max = higher d[di] max
   .
   len buck[][] radix
   pos = 1
   while pos <= max
      for i = 1 to radix : len buck[i][] 0
      for di = 1 to len d[]
         h = d[di] div pos mod radix + 1
         buck[h][] &= d[di]
      .
      di = 1
      for i = 1 to radix
         for j = 1 to len buck[i][]
            d[di] = buck[i][j]
            di += 1
         .
      .
      pos *= radix
   .
.
data[] = [ 29 4 72 44 55 26 27 77 92 5 ]
sort data[]
print data[]
