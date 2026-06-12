nums[][] = [ [ 2 5 1 3 8 9 4 6 ] [ 3 5 6 2 9 8 4 ] [ 1 3 7 6 9 ] ]
#
proc sort &d[] .
   for i = 1 to len d[] - 1
      for j = i + 1 to len d[]
         if d[j] < d[i] : swap d[j] d[i]
      .
   .
.
#
for l to len nums[][] : for e in nums[l][]
   h[] &= e
.
sort h[]
for e in h[]
   if e <> last or len r[] = 0
      r[] &= e
      last = e
   .
.
print r[]
