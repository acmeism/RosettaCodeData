scalars[][] = [ [ 1 2 3 ] [ 0 1 2 3 ] [ 1 0 3 4 ] [ 1 2 0 ] [ 0 0 0 ] [ 0 ] [ 1 1 1 ] [ -1 -1 -1 ] [ -1 -2 0 -3 ] [ -1 ] ]
for n = 1 to len scalars[][]
   str$ = ""
   for m = 1 to len scalars[n][]
      scalar = scalars[n][m]
      if scalar <> 0
         if scalar = 1
            str$ &= "+e" & m
         elif scalar = -1
            str$ &= "-e" & m
         else
            if scalar > 0
               str$ &= strchar 43 & scalar & "*e" & m
            else
               str$ = scalar & "*e" & m
            .
         .
      .
   .
   if str$ = ""
      str$ = 0
   .
   if substr str$ 1 1 = "+"
      str$ = substr str$ 2 (len str$ - 1)
   .
   print str$
.
