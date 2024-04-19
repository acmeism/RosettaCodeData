func gapful n .
   m = n
   l = n mod 10
   while m >= 10
      m = m div 10
   .
   return if n mod (m * 10 + l) = 0
.
proc show n gaps . .
   print "First " & gaps & " gapful numbers >= " & n
   while inc < gaps
      if gapful n = 1
         write n & " "
         inc += 1
      .
      n += 1
   .
   print ""
   print ""
.
show 100 30
show 1000000 15
show 1000000000 10
