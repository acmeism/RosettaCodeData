fastfunc isForbidden n .
   m = n
   p4 = 1
   while m > 1 and m mod 4 = 0
      m /= 4
      p4 *= 4
   .
   if (n / p4) mod 8 = 7 : return 1
   return 0
.
fCount = 0
nextToShow = 500
for i = 1 to 500000
   if isForbidden i = 1
      fCount += 1
      if fCount <= 50
         write " " & i
         if fCount mod 10 = 0 : print ""
      .
   .
   if i = nextToShow
      print "There are " & fCount & " Forbidden numbers up to " & i
      nextToShow *= 10
   .
.
