sysconf zero_based
print "Unsigned Stirling numbers of the second kind:"
len a[] 13
len b[] 13
a[0] = 1
print 1
for n = 1 to 12
   b[0] = 0
   write 0 & " "
   for k = 1 to n - 1
      b[k] = k * a[k] + a[k - 1]
      write b[k] & " "
   .
   b[n] = 1
   write 1 & " "
   print ""
   swap a[] b[]
.
