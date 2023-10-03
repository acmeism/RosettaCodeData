func fac n .
   r = 1
   for i = 2 to n
      r *= i
   .
   return r
.
print 0
print "0 1"
for n = 2 to 12
   write 0 & " " & fac n & " "
   for k = 2 to n - 1
      write fac n * fac (n - 1) / (fac k * fac (k - 1)) / fac (n - k) & " "
   .
   print 1 & " "
.
