func median t[] low high .
   l = high - low + 1
   m = low + l div 2
   if l mod 2 = 1 : return t[m]
   return (t[m - 1] + t[m]) / 2
.
proc sort &d[] .
   for i = 1 to len d[] - 1
      for j = i + 1 to len d[]
         if d[j] < d[i] : swap d[j] d[i]
      .
   .
.
func[] fivenum t[] .
   sort t[]
   l = len t[]
   m = l div 2 + l mod 2
   r1 = t[1]
   r2 = median t[] 1 m
   r3 = median t[] 1 l
   r4 = median t[] (m + 1) l
   r5 = t[l]
   return [ r1 r2 r3 r4 r5 ]
.
print fivenum [ 0.14082834 0.09748790 1.73131507 0.87636009 -1.95059594 0.73438555 -0.03035726 1.46675970 -0.74621349 -0.72588772 0.63905160 0.61501527 -0.98983780 -1.00447874 -0.62759469 0.66206163 1.04312009 -0.10305385 0.75775634 0.32566578 ]
print fivenum [ 36 40 7 39 41 15 ]
