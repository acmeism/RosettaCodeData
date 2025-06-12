func shoelace &p[][] .
   for i = 1 to len p[][] - 1
      sum += p[i][1] * p[i + 1][2]
      sum -= p[i + 1][1] * p[i][2]
   .
   sum += p[i][1] * p[1][2]
   sum -= p[1][1] * p[i][2]
   return abs sum / 2
.
data[][] = [ [ 3 4 ] [ 5 11 ] [ 12 8 ] [ 9 5 ] [ 5 6 ] ]
print shoelace data[][]
