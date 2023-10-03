print "Unsigned Stirling numbers of the first kind:"
len a[] 13 ; arrbase a[] 0
len b[] 13 ; arrbase b[] 0
a[0] = 1
print 1
for n = 1 to 12
   b[0] = 0
   write 0 & " "
   for k = 1 to n
      b[k] = a[k - 1] + (n - 1) * a[k]
      write b[k] & " "
   .
   print ""
   swap a[] b[]
.
