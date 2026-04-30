fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
for i = 42 to pow 2 53
   if isprim i = 1
      cnt += 1
      if cnt <= 5 or cnt >= 38
         print "n=" & cnt & " " & i
      elif cnt mod 15 = 0
         print "."
      .
      if cnt >= 42 : break 1
      i += i - 1
   .
.
