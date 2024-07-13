func[][] krpr a[][] b[][] .
   for m = 1 to len a[][]
      for p = 1 to len b[][]
         r[][] &= [ ]
         for n = 1 to len a[m][]
            for q = 1 to len b[p][]
               r[$][] &= a[m][n] * b[p][q]
            .
         .
      .
   .
   return r[][]
.
func[][] krpow a[][] n .
   r[][] = [ [ 1 ] ]
   for i to n
      r[][] = krpr a[][] r[][]
   .
   return r[][]
.
proc show p[][] . .
   clear
   n = len p[][]
   sc = 100 / n
   for r to n
      for c to n
         x = (c - 1) * sc
         y = (r - 1) * sc
         move x y
         if p[r][c] = 1
            rect sc sc
         .
      .
   .
.
show krpow [ [ 1 1 1 ] [ 1 0 1 ] [ 1 1 1 ] ] 5
sleep 2
show krpow [ [ 0 1 0 ] [ 1 1 1 ] [ 0 1 0 ] ] 5
