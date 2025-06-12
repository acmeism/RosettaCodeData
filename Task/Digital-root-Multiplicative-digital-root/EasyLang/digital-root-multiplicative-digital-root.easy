proc _mdr n &md &mp .
   if n > 0 : r = 1
   while n > 0
      r *= n mod 10
      n = n div 10
   .
   mp += 1
   if r >= 10
      _mdr r md mp
   else
      md = r
   .
.
proc mdr n &md &mp .
   mp = 0
   _mdr n md mp
.
numfmt 6 0
print "Number    MDR    MP"
for v in [ 123321 7739 893 899998 ]
   mdr v md mp
   print v & md & mp
.
width = 5
len table[] 10 * width
arrbase table[] 0
len tfill[] 10
arrbase tfill[] 0
numfmt 0 0
while total < 10 * width
   mdr i md mp
   if tfill[md] < width
      table[md * width + tfill[md]] = i
      tfill[md] += 1
      total += 1
   .
   i += 1
.
print "\nMDR: [n0..n4]"
for i = 0 to 9
   write i & ": ["
   for j = 0 to width - 1
      write table[i * width + j]
      if j < width - 1 : write ","
   .
   print "]"
.
