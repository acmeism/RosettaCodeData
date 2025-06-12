func det &a0[][] .
   res = 1
   a[][] = a0[][]
   n = len a[][]
   for j to n
      imax = j
      for i = j + 1 to n
         if a[i][j] > a[imax][j] : imax = i
      .
      if imax <> j
         swap a[imax][] a[j][]
         res = -res
      .
      if abs a[j][j] < 1e-12
         print "Singular matrix!"
         return 0 / 0
      .
      for i = j + 1 to n
         mult = -a[i][j] / a[j][j]
         for k to n
            a[i][k] += mult * a[j][k]
         .
      .
   .
   for i to n : res *= a[i][i]
   return res
.
func cramer_solve &a0[][] deta &b[] col .
   a[][] = a0[][]
   for i to len a[][]
      a[i][col] = b[i]
   .
   return det a[][] / deta
.
a[][] = [ [ 2 -1 5 1 ] [ 3 2 2 -6 ] [ 1 3 3 -1 ] [ 5 -2 -3 3 ] ]
b[] = [ -3 -32 -47 49 ]
deta = det a[][]
for i to len a[][]
   print cramer_solve a[][] deta b[] i
.
