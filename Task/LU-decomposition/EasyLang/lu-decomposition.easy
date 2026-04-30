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
func[][] midm n .
   len m[][] n
   for i to n
      len m[i][] n
      m[i][i] = 1
   .
   return m[][]
.
func[][] pivotize m[][] .
   n = len m[][]
   im[][] = midm n
   for i to n
      mx = abs m[i][i]
      fila = i
      for j = i to n
         if abs m[j][i] > mx
            mx = abs m[j][i]
            fila = j
         .
      .
      if i <> fila
         for j to n : swap im[i][j] im[fila][j]
      .
   .
   return im[][]
.
proc ludecomp a[][] &l[][] &u[][] &p[][] .
   n = len a[][]
   len l[][] n
   len u[][] n
   for i to n
      len l[i][] n
      len u[i][] n
   .
   p[][] = pivotize a[][]
   b[][] = mmul p[][] a[][]
   for j to n
      l[j][j] = 1
      for i to j
         s = 0
         for k to i - 1
            s += u[k][j] * l[i][k]
         .
         u[i][j] = b[i][j] - s
      .
      for i = j + 1 to n
         s = 0
         for k to j - 1
            s += u[k][j] * l[i][k]
         .
         l[i][j] = (b[i][j] - s) / u[j][j]
      .
   .
.
proc go a[][] .
   ludecomp a[][] l[][] u[][] p[][]
   print l[][]
   print u[][]
   print p[][]
   print ""
.
go [ [ 1 3 5 ] [ 2 4 7 ] [ 1 1 0 ] ]
go [ [ 11 9 24 2 ] [ 1 5 2 6 ] [ 3 17 18 1 ] [ 2 5 7 1 ] ]
