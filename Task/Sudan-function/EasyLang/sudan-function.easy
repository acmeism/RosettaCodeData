func f n x y .
   if n = 0
      return x + y
   .
   if y = 0
      return x
   .
   return f (n - 1) f n x (y - 1) (f n x (y - 1) + y)
.
print "F(1,3,3) = " & f 1 3 3
