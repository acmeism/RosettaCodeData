sysconf radians
func[] cmult a[] b[] .
   return [ a[1] * b[1] - a[2] * b[2] a[1] * b[2] + a[2] * b[1] ]
.
func[] cadd a[] b[] .
   return [ a[1] + b[1] a[2] + b[2] ]
.
func[] csub a[] b[] .
   return [ a[1] - b[1] a[2] - b[2] ]
.
func[] cexp a[] .
   p = pow 2.718281828459045235 a[1]
   return [ p * cos a[2] p * sin a[2] ]
.
func cabs a[] .
   return sqrt (a[1] * a[1] + a[2] * a[2])
.
proc fft x[] . y[][] .
   n = len x[]
   if n = 1
      y[][] = [ [ x[1] 0 ] ]
      return
   .
   for i = 1 step 2 to len x[]
      xeven[] &= x[i]
      xodd[] &= x[i + 1]
   .
   fft xeven[] even[][]
   fft xodd[] odd[][]
   y[][] = [ ]
   for k to n div 2
      t[][] &= cmult cexp [ 0 -2 * pi * (k - 1) / n ] odd[k][]
   .
   for k to n div 2
      y[][] &= cadd even[k][] t[k][]
   .
   for k to n div 2
      y[][] &= csub even[k][] t[k][]
   .
.
fft [ 1.0 1.0 1.0 1.0 0.0 0.0 0.0 0.0 ] r[][]
for i to len r[][]
   write cabs r[i][] & " "
.
