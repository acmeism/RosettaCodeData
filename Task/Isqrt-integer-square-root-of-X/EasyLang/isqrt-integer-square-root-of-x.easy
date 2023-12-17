func isqrt x .
   q = 1
   while q <= x
      q *= 4
   .
   while q > 1
      q = q div 4
      t = x - r - q
      r = r div 2
      if t >= 0
         x = t
         r = r + q
      .
   .
   return r
.
print "Integer square roots from 0 to 65:"
for n = 0 to 65
   write isqrt n & " "
.
print ""
print ""
print "Integer square roots of 7^n"
p = 7
n = 1
while n <= 21
   print n & " " & isqrt p
   n = n + 2
   p = p * 49
.
