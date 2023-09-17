func mul_inv a b .
   b0 = b
   x1 = 1
   if b <> 1
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
   .
   return x1
.
proc remainder . n[] a[] r .
   prod = 1
   sum = 0
   for i = 1 to len n[]
      prod *= n[i]
   .
   for i = 1 to len n[]
      p = prod / n[i]
      sum += a[i] * (mul_inv p n[i]) * p
      r = sum mod prod
   .
.
n[] = [ 3 5 7 ]
a[] = [ 2 3 2 ]
remainder n[] a[] h
print h
