func ceil h .
   f = floor h
   if h <> f : f += 1
   return f
.
proc triangle n .
   print n & " rows:"
   row = 1
   while row <= n
      printme += 1
      cols = ceil log10 (n * (n - 1) / 2 + nprinted + 2)
      numfmt cols 0
      write printme & " "
      nprinted += 1
      if nprinted = row
         print ""
         row += 1
         nprinted = 0
      .
   .
   print ""
.
triangle 5
triangle 14
