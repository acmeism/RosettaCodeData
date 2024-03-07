len mertens[] 1000
mertens[1] = 1
for n = 2 to 1000
   mertens[n] = 1
   for k = 2 to n
      mertens[n] -= mertens[n div k]
   .
.
print "First 99 Mertens numbers:"
write "   "
numfmt 0 2
for n = 1 to 99
   write mertens[n] & " "
   if n mod 10 = 9
      print ""
   .
.
for n = 1 to 1000
   if mertens[n] = 0
      zeros += 1
      if mertens[n - 1] <> 0
         crosses += 1
      .
   .
.
print ""
print "In the first 1000 terms of the Mertens sequence there are:"
print zeros & " zeros"
print crosses & " zero crosses"
