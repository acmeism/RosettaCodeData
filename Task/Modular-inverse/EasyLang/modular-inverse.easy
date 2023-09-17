func mod_inv a b .
   b0 = b
   x1 = 1
   if b = 1
      return 1
   .
   while a > 1
      q = a div b
      t = b
      b = a mod b
      a = t
      t = x0
      x0 = x1 - q * x0
      x1 = t
   .
   if x1 < 0
      x1 += b0
   .
   return x1
.
print mod_inv 42 2017
