func[][] minor a[][] x y .
   l = len a[][] - 1
   for i = 1 to l
      r[][] &= [ ]
      for j = 1 to l
         r[i][] &= a[i + if i >= x][j + if j >= y]
      .
   .
   return r[][]
.
func det a[][] .
   if len a[][] = 1
      return a[1][1]
   .
   sgn = 1
   for i = 1 to len a[][]
      res += sgn * a[1][i] * det minor a[][] 1 i
      sgn *= -1
   .
   return res
.
func perm a[][] .
   if len a[][] = 1
      return a[1][1]
   .
   for i = 1 to len a[][]
      res += a[1][i] * perm minor a[][] 1 i
   .
   return res
.
t[][] = [ [ 1 2 ] [ 3 4 ] ]
print det t[][] & " " & perm t[][]
t[][] = [ [ 2 9 4 ] [ 7 5 3 ] [ 6 1 8 ] ]
print det t[][] & " " & perm t[][]
