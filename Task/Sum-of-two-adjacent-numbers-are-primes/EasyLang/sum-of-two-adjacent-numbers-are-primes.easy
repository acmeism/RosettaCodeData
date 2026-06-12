fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
print "The first 20 pairs of numbers whose sum is prime:"
repeat
   n += 1
   sum = 2 * n + 1
   if isprim sum = 1
      print n & " + " & n + 1 & " = " & sum
      cnt += 1
   .
   until cnt = 20
.
