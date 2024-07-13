fastfunc digsum h .
   while h > 0
      sum += h mod 10
      h = h div 10
   .
   return sum
.
fastfunc isself start i .
   j = start
   sum = digsum start
   while j < i
      if j + sum = i
         return 0
      .
      sum += 1
      j += 1
      if j mod 10 = 0
         sum = digsum j
      .
   .
   return 1
.
proc main . .
   i = 1
   po = 10
   digits = 1
   offs = 9
   repeat
      start = higher (i - offs) 0
      if isself start i = 1
         cnt += 1
         if cnt <= 50
            write i & " "
         .
      .
      until cnt = 100000000
      i += 1
      if i mod po = 0
         po *= 10
         digits += 1
         offs = digits * 9
      .
   .
   print ""
   print i
.
main
