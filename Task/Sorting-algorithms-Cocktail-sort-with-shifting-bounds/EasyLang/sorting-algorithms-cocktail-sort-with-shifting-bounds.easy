proc cktlShakerSort &a[] .
   a = 1
   b = len a[] - 1
   while a <= b
      an = b
      bn = a
      for i = a to b
         if a[i] > a[i + 1]
            swap a[i] a[i + 1]
            bn = i
         .
      .
      b = bn - 1
      for i = b downto a
         if a[i] > a[i + 1]
            swap a[i] a[i + 1]
            an = i
         .
      .
      a = an + 1
   .
.
a[] = [ 4 38 100 1 25 69 69 16 8 59 71 53 33 ]
cktlShakerSort a[]
print a[]
