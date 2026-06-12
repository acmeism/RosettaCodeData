lists[][] = [ [ 3 4 34 25 9 12 36 56 36 ] [ 2 8 81 169 34 55 76 49 7 ] [ 75 121 75 144 35 16 46 35 ] ]
#
proc sort &d[] .
   for i = 1 to len d[] - 1
      for j = i + 1 to len d[]
         if d[j] < d[i] : swap d[j] d[i]
      .
   .
.
func issqr x .
   return if pow floor sqrt x 2 = x
.
for i to len lists[][]
   for e in lists[i][]
      if issqr e = 1 : sqrs[] &= e
   .
.
sort sqrs[]
print sqrs[]
