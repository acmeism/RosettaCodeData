proc juggler a &cnt &max &maxidx .
   max = a
   maxidx = 0
   cnt = 0
   while a <> 1
      if a mod 2 = 0
         a = floor sqrt a
      else
         a = floor (a * sqrt a)
      .
      cnt += 1
      if a > max
         max = a
         maxidx = cnt
      .
   .
.
numfmt 6 0
print " n l[n]           h[n]   i[n]"
print "-----------------------------"
for n = 20 to 39
   juggler n cnt max maxidx
   numfmt 3 0
   write n & cnt
   numfmt 16 0
   write max
   numfmt 5 0
   print maxidx
.
