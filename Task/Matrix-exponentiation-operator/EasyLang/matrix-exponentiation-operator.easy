func[][] mmul m1[][] m2[][] .
   for i to len m1[][]
      r[][] &= [ ]
      for j = 1 to len m2[1][]
         r[i][] &= 0
         for k to len m2[][]
            r[i][j] += m1[i][k] * m2[k][j]
         .
      .
   .
   return r[][]
.
func[][] mexp m[][] e .
   n = len m[][]
   len r[][] n
   for i to n
      len r[i][] n
      r[i][i] = 1
   .
   for i to e
      r[][] = mmul r[][] m[][]
   .
   return r[][]
.
print mexp [ [ 4 3 ] [ 2 1 ] ] 3
