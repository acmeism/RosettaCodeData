proc mpos n .
   a[] = [ 1 2 5 13 57 72 89 104 ]
   b[] = [ -1 15 25 35 72 21 58 7 ]
   i = len a[]
   while a[i] > n : i -= 1
   m = n + b[i]
   r = m div 18 + 1
   c = m mod 18 + 1
   print "Atomic number " & n & "-> " & r & ", " & c
.
elem[] = [ 1 2 29 42 57 58 59 71 72 89 90 103 113 ]
for e in elem[] : mpos e
