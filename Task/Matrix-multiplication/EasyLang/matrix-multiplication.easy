proc matmul . m1[][] m2[][] r[][] .
   r[][] = [ ]
   for i to len m1[][]
      r[][] &= [ ]
      for j = 1 to len m2[1][]
         r[i][] &= 0
         for k to len m2[][]
            r[i][j] += m1[i][k] * m2[k][j]
         .
      .
   .
.
mat1[][] = [ [ 1 2 3 ] [ 4 5 6 ] ]
mat2[][] = [ [ 1 2 ] [ 3 4 ] [ 5 6 ] ]
matmul mat1[][] mat2[][] erg[][]
print erg[][]
