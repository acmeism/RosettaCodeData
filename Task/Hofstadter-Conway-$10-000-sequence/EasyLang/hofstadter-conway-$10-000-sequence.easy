numfmt 0 4
a[] = [ 1 1 ]
x = 1
n = 2
mallow = 0
for p = 1 to 19
   max = 0
   nextPot = n * 2
   while n < nextPot
      n = len a[] + 1
      x = a[x] + a[n - x]
      a[] &= x
      f = x / n
      max = higher max f
      if f >= 0.55 : mallow = n
   .
   print "max between 2^" & p & " and 2^" & p + 1 & " was " & max
.
print "winning number " & mallow
