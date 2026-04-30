func sphenic n .
   l = sqrt n
   f = 2
   while f <= n
      if n mod f = 0
         nfacts += 1
         n = n div f
         if n mod f = 0 : return 0
      else
         f += 1
         if f > l
            nfacts += 1
            break 1
         .
      .
   .
   return if nfacts = 3
.
print "Sphenic numbers less than 1000:"
for n = 1 to 999
   if sphenic n = 1
      cnt += 1
      write n & " "
      if cnt mod 15 = 0 : print ""
   .
.
print ""
#
print "Sphenic triplets less than 10000:"
for n = 1 to 9990
   if sphenic n = 1 and sphenic (n + 1) = 1 and sphenic (n + 2) = 1
      cnt += 1
      write "[" & n & "-" & n + 2 & "] "
      if cnt mod 3 = 0 : print ""
   .
.
