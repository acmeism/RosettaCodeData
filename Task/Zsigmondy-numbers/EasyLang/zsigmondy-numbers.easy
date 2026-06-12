fastfunc isprim num .
   if num < 2 : return 0
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
proc sort &d[] .
   for i = 1 to len d[] - 1 : for j = i + 1 to len d[]
      if d[j] < d[i] : swap d[j] d[i]
   .
.
proc divisors num &res[] .
   res[] = [ ]
   d = 1
   while d <= sqrt num
      if num mod d = 0
         res[] &= d
         if d <> sqrt num
            res[] &= num / d
         .
      .
      d += 1
   .
   sort res[]
.
func gcd a b .
   if b = 0 : return a
   return gcd b (a mod b)
.
func zsigmo n a b .
   dn = pow a n - pow b n
   if isprim dn = 1 : return dn
   divisors dn divs[]
   for m = 1 to n - 1
      dms[] &= pow a m - pow b m
   .
   for i = len divs[] downto 1
      d = divs[i]
      for m = 1 to n - 1
         if gcd dms[m] d <> 1 : break 1
      .
      if m = n : return d
   .
   return 1
.
proc test .
   test[][] = [ [ 2 1 ] [ 3 1 ] [ 4 1 ] [ 5 1 ] [ 6 1 ] [ 7 1 ] [ 3 2 ] [ 5 3 ] [ 7 3 ] [ 7 5 ] ]
   for i to len test[][]
      a = test[i][1]
      b = test[i][2]
      write "Zsigmondy(n, " & a & ", " & b & "):"
      for n = 1 to 10 : write " " & zsigmo n a b
      print ""
   .
.
test
