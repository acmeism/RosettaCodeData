func[][] cholesky a[][] .
   n = len a[][]
   len r[][] n
   for i to n
      len r[i][] n
      for j to i
         s = 0
         for k to j : s += r[i][k] * r[j][k]
         if i = j
            r[i][j] = sqrt (a[i][i] - s)
         else
            r[i][j] = 1 / r[j][j] * (a[i][j] - s)
         .
      .
   .
   return r[][]
.
print cholesky [ [ 25 15 -5 ] [ 15 18 0 ] [ -5 0 11 ] ]
print cholesky [ [ 18 22 54 42 ] [ 22 70 86 62 ] [ 54 86 174 134 ] [ 42 62 134 106 ] ]
