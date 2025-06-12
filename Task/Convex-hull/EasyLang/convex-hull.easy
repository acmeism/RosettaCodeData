func orientation p[] q[] r[] .
   return (q[2] - p[2]) * (r[1] - q[1]) - (q[1] - p[1]) * (r[2] - q[2])
.
func[][] convexHull &pts[][] .
   indMinX = 1
   for i to len pts[][]
      if pts[i][1] < pts[indMinX][1] : indMinX = i
   .
   p = indMinX
   repeat
      res[][] &= pts[p][]
      q = (p + 1) mod1 len pts[][]
      for i to len pts[][]
         if orientation pts[p][] pts[i][] pts[q][] < 0 : q = i
      .
      p = q
      until p = indMinX
   .
   return res[][]
.
#
pts[][] = [ [ 16 3 ] [ 12 17 ] [ 0 6 ] [ -4 -6 ] [ 16 6 ] [ 16 -7 ] [ 16 -3 ] [ 17 -4 ] [ 5 19 ] [ 19 -8 ] [ 3 16 ] [ 12 13 ] [ 3 -4 ] [ 17 5 ] [ -3 15 ] [ -3 -9 ] [ 0 11 ] [ -9 -3 ] [ -4 -2 ] [ 12 10 ] ]
print convexHull pts[][]
