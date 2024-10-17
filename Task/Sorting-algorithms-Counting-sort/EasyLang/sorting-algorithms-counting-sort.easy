proc countsort min max . d[] .
   len count[] max - min + 1
   for n in d[]
      count[n - min + 1] += 1
   .
   z = 1
   for i = min to max
      while count[i - min + 1] > 0
         d[z] = i
         z += 1
         count[i - min + 1] -= 1
      .
   .
.
for i = 1 to 100
   d[] &= random 1000
.
countsort 1 1000 d[]
print d[]
