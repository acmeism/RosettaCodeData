func mulinv a b .
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
      if x1 < 0 : x1 += b0
   .
   return x1
.
func remainder &n[] &a[] .
   prod = 1
   for i = 1 to len n[]
      prod *= n[i]
   .
   for i = 1 to len n[]
      p = prod / n[i]
      sum += a[i] * (mulinv p n[i]) * p
   .
   return sum mod prod
.
n[] = [ 3 5 7 ]
a[] = [ 2 3 2 ]
print remainder n[] a[]
