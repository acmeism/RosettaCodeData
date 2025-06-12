proc stsort left right &d[] .
   if d[left] > d[right] : swap d[left] d[right]
   if right - left + 1 > 2
      t = (right - left + 1) div 3
      stsort left right - t d[]
      stsort left + t right d[]
      stsort left right - t d[]
   .
.
for i = 1 to 100 : d[] &= random 1000
stsort 1 len d[] d[]
print d[]
