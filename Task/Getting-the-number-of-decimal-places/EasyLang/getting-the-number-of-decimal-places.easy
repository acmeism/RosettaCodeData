func ndec n .
   while abs (n - floor (n + 1e-15)) > 1e-15
      n *= 10
      r += 1
   .
   return r
.
for i in [ 0.00000000000001 12.345 12.3450 1.1 0.1234567 ]
   write ndec i & " "
.
