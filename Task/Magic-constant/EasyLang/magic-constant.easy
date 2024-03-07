func a n .
   n += 2
   return n * (n * n + 1) / 2
.
func inva x .
   while k * (k * k + 1) / 2 + 2 < x
      k += 1
   .
   return k
.
write "The first 20 magic constants: "
for n to 20
   write a n & " "
.
print ""
print ""
print "The 1,000th magic constant: " & a 1000
print ""
print "Smallest magic square with constant greater than:"
for e to 10
   print "10^" & e & ": " & inva pow 10 e
.
