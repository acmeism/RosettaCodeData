func root base n .
   if base < 2 : return base
   if n = 0 : return 1
   n1 = n - 1
   n2 = n
   n3 = n1
   c = 1
   d = (n3 + base) div n2
   e = (n3 * d + base div pow d n1) div n2
   while c <> d and c <> e
      c = d
      d = e
      e = (n3 * e + base div pow e n1) div n2
   .
   if d < e : return d
   return e
.
print "3rd root of 8 = " & root 8 3
print "3rd root of 9 = " & root 9 3
b = 2e18
print "2nd root of " & b & " = " & root b 2
