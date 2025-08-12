func[] gauss_elim a[][] b[] .
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
         fn = a[j][i]
         fd = a[i][i]
         for k = i to n
            a[j][k] -= a[i][k] * fn / fd
         .
         b[j] -= b[i] * fn / fd
      .
   .
   len x[] n
   for i = n downto 1
      rhs = b[i]
      for j = i + 1 to n
         rhs -= a[i][j] * x[j]
      .
      x[i] = rhs / a[i][i]
   .
   return x[]
.
# --------------------- #
#   2x + 3y −  z =  5   #
#    x +  y +  z =  6   #
#  -3x - 4y + 3z = -5   #
#                       #
#  x = 5, y = -1, z = 2 #
# --------------------- #
#
a[][] = [ [ 2 3 -1 ] [ 1 1 1 ] [ -3 -4 3 ] ]
b[] = [ 5 6 -5 ]
print gauss_elim a[][] b[]
