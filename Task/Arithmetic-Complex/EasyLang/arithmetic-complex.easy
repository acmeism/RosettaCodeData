func[] cadd a[] b[] .
   return [ a[1] + b[1] a[2] + b[2] ]
.
func[] cmult a[] b[] .
   return [ a[1] * b[1] - a[2] * b[2] a[1] * b[2] + a[2] * b[1] ]
.
func[] cinv a[] .
   denom = a[1] * a[1] + a[2] * a[2]
   return [ a[1] / denom (-a[2] / denom) ]
.
func[] cneg a[] .
   return [ -a[1] (-a[2]) ]
.
a[] = [ 1 1 ]
b[] = [ pi 1.2 ]
print cadd a[] b[]
print cmult a[] b[]
print cneg a[]
print cinv a[]
