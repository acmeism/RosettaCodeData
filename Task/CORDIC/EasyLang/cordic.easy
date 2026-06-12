func cordic_cos a .
   pot[] = [ 1, 0.1, 0.01, 0.001, 0.0001, 0.00001 ]
   tbl[] = [ 7.853981633e-1 9.966865249e-2 9.999666686e-3 9.999996666e-4 9.999999966e-5 9.999999999e-6 0 ]
   k = 1
   x = 1
   while a > 1e-5
      while a < tbl[k] : k += 1
      a -= tbl[k]
      h = x
      x -= pot[k] * y
      y += pot[k] * h
   .
   return x / sqrt (x * x + y * y)
.
for angle in [ -9 0 1.5 6 ]
   r = cordic_cos abs angle
   numfmt 3 1
   write angle & ": "
   numfmt 6 4
   print r
.
