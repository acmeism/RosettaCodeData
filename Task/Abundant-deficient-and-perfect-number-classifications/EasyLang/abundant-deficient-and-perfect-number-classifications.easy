func sumprop num .
   if num < 2
      return 0
   .
   i = 2
   sum = 1
   root = sqrt num
   while i < root
      if num mod i = 0
         sum += i + num / i
      .
      i += 1
   .
   if num mod root = 0
      sum += root
   .
   return sum
.
for j = 1 to 20000
   sump = sumprop j
   if sump < j
      deficient += 1
   elif sump = j
      perfect += 1
   else
      abundant += 1
   .
.
print "Perfect: " & perfect
print "Abundant: " & abundant
print "Deficient: " & deficient
