func fairshare ind base .
   while ind > 0
      r += ind mod base
      ind = ind div base
   .
   r = r mod base
   return r
.
proc sequence n base . .
   write base & ": "
   for ind range0 n
      write (fairshare ind base) & " "
   .
   print ""
.
sequence 25 2
sequence 25 3
sequence 25 5
sequence 25 11
