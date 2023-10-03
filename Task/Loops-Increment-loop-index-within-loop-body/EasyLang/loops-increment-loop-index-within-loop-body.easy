fastfunc isprim num .
   if num mod 2 = 0 and num > 2
      return 0
   .
   i = 3
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 2
   .
   return 1
.
counter = 0
maxnum = pow 2 53
for i = 42 to maxnum
   if isprim i = 1
      counter += 1
      print "n=" & counter & " " & i
      if counter >= 42
         break 1
      .
      i += i - 1
   .
.
