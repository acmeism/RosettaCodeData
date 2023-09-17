fastfunc risefall n .
   if n < 10
      return 1
   .
   prev = -1
   while n > 0
      d = n mod 10
      if prev >= 0
         if d < prev
            rises += 1
         elif d > prev
            falls += 1
         .
      .
      prev = d
      n = n div 10
   .
   if rises = falls
      return 1
   .
   return 0
.
numfmt 0 4
n = 1
repeat
   if risefall n = 1
      cnt += 1
      if cnt <= 200
         write n
         if cnt mod 20 = 0
            print ""
         .
      .
   .
   until cnt = 1e7
   n += 1
.
print ""
print n
