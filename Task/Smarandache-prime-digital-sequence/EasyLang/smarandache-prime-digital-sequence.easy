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
n = 2
repeat
   if isprim n = 1
      h = n
      while h > 0
         d = h mod 10
         if d < 2 or d = 4 or d = 6 or d > 7
            break 1
         .
         h = h div 10
      .
      if h = 0
         cnt += 1
         if cnt <= 25
            write n & " "
         .
      .
   .
   until cnt = 100
   n += 1
.
print ""
print n
