func valid n nuts .
   k = n
   while k <> 0
      if nuts mod n <> 1
         return 0
      .
      k -= 1
      nuts -= 1 + nuts div n
   .
   return if nuts <> 0 and nuts mod n = 0
.
for n = 5 to 6
   x = 0
   while valid n x = 0
      x += 1
   .
   print n & ": " & x
.
