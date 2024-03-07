proc gauss_elim . a[][] b[] x[] .
   n = len a[][]
   for i to n
      maxr = i
      maxv = abs a[i][i]
      for j = i + 1 to n
         if abs a[j][i] > maxv
            maxr = j
            maxv = abs a[j][i]
         .
      .
      if maxr <> i
         swap a[maxr][] a[i][]
         swap b[maxr] b[i]
      .
      for j = i + 1 to n
         f = a[j][i] / a[i][i]
         for k = i to n
            a[j][k] -= f * a[i][k]
         .
         b[j] -= f * b[i]
      .
   .
   x[] = [ ]
   len x[] n
   for i = n downto 1
      rhs = b[i]
      for j = i + 1 to n
         rhs -= a[i][j] * x[j]
      .
      x[i] = rhs / a[i][i]
   .
.
a[][] = [ [ 1.00 0.00 0.00 0.00 0.00 0.00 ] [ 1.00 0.63 0.39 0.25 0.16 0.10 ] [ 1.00 1.26 1.58 1.98 2.49 3.13 ] [ 1.00 1.88 3.55 6.70 12.62 23.80 ] [ 1.00 2.51 6.32 15.88 39.90 100.28 ] [ 1.00 3.14 9.87 31.01 97.41 306.02 ] ]
b[] = [ -0.01 0.61 0.91 0.99 0.60 0.02 ]
gauss_elim a[][] b[] x[]
print x[]
