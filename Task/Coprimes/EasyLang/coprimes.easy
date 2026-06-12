func gcd a b .
   if b = 0 : return a
   return gcd b (a mod b)
.
proc test p[] .
   if gcd p[1] p[2] = 1
      print p[]
   .
.
pairs[][] = [ [ 21 15 ] [ 17 23 ] [ 36 12 ] [ 18 29 ] [ 60 15 ] ]
for i to len pairs[][]
   test pairs[i][]
.
