fastfunc isprim num .
   if num mod 2 = 0 and num > 2 : return 0
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
indN = 1
indM = 2
numP = 2
numC = 4
sumP = 2
sumC = 4
#
numfmt 11 0
print "        sum     primes composites"
repeat
   if sumC > sumP
      repeat
         numP += 1
         until isprim numP = 1
      .
      sumP += numP
      indN += 1
   .
   if sumP > sumC
      repeat
         numC += 1
         until isprim numC = 0
      .
      sumC += numC
      indM += 1
   .
   if sumP = sumC
      print sumP & indN & indM
      cnt += 1
      if cnt < 8
         repeat
            numC += 1
            until isprim numC = 0
         .
         sumC += numC
         indM += 1
      .
   .
   until cnt >= 8
.
