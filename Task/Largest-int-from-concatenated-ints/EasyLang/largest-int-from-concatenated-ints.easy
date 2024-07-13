func con a b .
   t = 10
   while b >= t
      t *= 10
   .
   return a * t + b
.
func$ max a[] .
   n = len a[]
   for i to n - 1
      for j = i + 1 to n
         if con a[i] a[j] < con a[j] a[i]
            swap a[i] a[j]
         .
      .
   .
   for v in a[]
      r$ &= v
   .
   return r$
.
print max [ 1 34 3 98 9 76 45 4 ]
print max [ 54 546 548 60 ]
