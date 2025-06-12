numfmt 4 0
proc pascal n .
   r[] = [ 1 ]
   for i to n
      rn[] = [ ]
      l = 0
      for j to n - len r[] : write "  "
      for r in r[]
         write r
         rn[] &= l + r
         l = r
      .
      print ""
      rn[] &= l
      swap r[] rn[]
   .
.
pascal 13
