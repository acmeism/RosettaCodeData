func det2d t[][] .
   return t[1][1] * (t[2][2] - t[3][2]) + t[2][1] * (t[3][2] - t[1][2]) + t[3][1] * (t[1][2] - t[2][2])
.
proc triwind . t[][] .
   det = det2d t[][]
   if det < 0
      swap t[1][] t[2][]
   .
.
func overlap t1[][] t2[][] .
   triwind t1[][]
   triwind t2[][]
   for t to 2
      for i to 3
         j = (i + 1) mod1 3
         for k to 3
            if det2d [ t1[i][] t1[j][] t2[k][] ] >= 0
               break 1
            .
         .
         if k = 4
            return 0
         .
      .
      swap t1[][] t2[][]
   .
   return 1
.
print overlap [ [ 0 0 ] [ 5 0 ] [ 0 5 ] ] [ [ 0 0 ] [ 5 0 ] [ 0 6 ] ]
print overlap [ [ 0 0 ] [ 0 5 ] [ 5 0 ] ] [ [ 0 0 ] [ 0 5 ] [ 5 0 ] ]
print overlap [ [ 0 0 ] [ 5 0 ] [ 0 5 ] ] [ [ -10 0 ] [ -5 0 ] [ -1 6 ] ]
print overlap [ [ 0 0 ] [ 5 0 ] [ 2.5 5 ] ] [ [ 0 4 ] [ 2.5 -1 ] [ 5 4 ] ]
print overlap [ [ 0 0 ] [ 1 1 ] [ 0 2 ] ] [ [ 2 1 ] [ 3 0 ] [ 3 2 ] ]
print overlap [ [ 0 0 ] [ 1 1 ] [ 0 2 ] ] [ [ 2 1 ] [ 3 -2 ] [ 3 4 ] ]
