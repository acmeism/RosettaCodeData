func factorial n .
   r = 1
   for i = 2 to n : r *= i
   return r
.
func inv_factorial f .
   if f = 1 : return 0
   p = 1
   while p < f
      i += 1
      p *= i
   .
   if p = f : return i
   return -1
.
func super_factorial n .
   r = 1
   for i = 1 to n : r *= factorial i
   return r
.
func hyper_factorial n .
   r = 1
   for i = 1 to n : r *= pow i i
   return r
.
func alter_factorial n .
   for i = 1 to n
      if (n - i) mod 2 = 0
         r += factorial i
      else
         r -= factorial i
      .
   .
   return r
.
func exp_factorial n .
   for i = 1 to n : r = pow i r
   return r
.
print "First 9 super factorials:"
for i = 0 to 8
   write super_factorial i & " "
.
print ""
print ""
print "First 7 hyper factorials:"
for i = 0 to 6
   write hyper_factorial i & " "
.
print ""
print ""
print "First 10 alternating factorials:"
for i = 0 to 9
   write alter_factorial i & " "
.
print ""
print ""
print "First 5 exponential factorials:"
for i = 0 to 4
   write exp_factorial i & " "
.
print ""
print ""
#
print "Inverse factorial:"
for e in [ 1 2 6 24 120 720 5040 40320 362880 3628800 119 ]
   n = inv_factorial e
   write e & " -> "
   if n < 0
      print "no solution"
   else
      print n
   .
.
