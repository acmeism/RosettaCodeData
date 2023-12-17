proc mean . v[] a g h .
   prod = 1
   for v in v[]
      sum += v
      prod *= v
      resum += 1 / v
   .
   a = sum / len v[]
   g = pow prod (1 / len v[])
   h = len v[] / resum
.
a[] = [ 1 2 3 4 5 6 7 8 9 10 ]
mean a[] a g h
print a
print g
print h
