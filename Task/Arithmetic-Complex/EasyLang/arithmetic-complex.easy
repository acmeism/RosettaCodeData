func[] add a[] b[] .
   return [ a[1] + b[1] a[2] + b[2] ]
.
func[] mult a[] b[] .
   return [ a[1] * b[1] - a[2] * b[2] a[1] * b[2] + a[2] * b[1] ]
.
func[] inv a[] .
   denom = a[1] * a[1] + a[2] * a[2]
   return [ a[1] / denom (-a[2] / denom) ]
.
func[] neg a[] .
   return [ -a[1] (-a[2]) ]
.
a[] = [ 1 1 ]
b[] = [ pi 1.2 ]
print add a[] b[]
print mult a[] b[]
print neg a[]
print inv a[]
