func hypo a b .
   return sqrt (a * a + b * b)
.
nsites = 25
for i to nsites
   nx[] &= random 1001 - 1
   ny[] &= random 1001 - 1
   nc[] &= random 1000 - 1
.
for y = 0 to 1000
   for x = 0 to 1000
      dmin = 1 / 0
      for i to nsites
         d = hypo (nx[i] - x) (ny[i] - y)
         if d < dmin
            dmin = d
            imin = i
         .
      .
      color nc[imin]
      move x / 10 - 0.05 y / 10 - 0.05
      rect 0.11 0.11
   .
.
color 000
for i to nsites
   move nx[i] / 10 ny[i] / 10
   circle 0.5
.
