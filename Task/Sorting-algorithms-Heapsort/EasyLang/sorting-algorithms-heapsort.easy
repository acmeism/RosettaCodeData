proc sort &d[] .
   n = len d[]
   # make heap
   for i = 2 to n
      if d[i] > d[(i + 1) div 2]
         j = i
         repeat
            h = (j + 1) div 2
            until d[j] <= d[h]
            swap d[j] d[h]
            j = h
         .
      .
   .
   for i = n downto 2
      swap d[1] d[i]
      j = 1
      ind = 2
      while ind < i
         if ind + 1 < i and d[ind + 1] > d[ind] : ind += 1
         if d[j] < d[ind] : swap d[j] d[ind]
         j = ind
         ind = 2 * j
      .
   .
.
data[] = [ 29 4 72 44 55 26 27 77 92 5 ]
sort data[]
print data[]
