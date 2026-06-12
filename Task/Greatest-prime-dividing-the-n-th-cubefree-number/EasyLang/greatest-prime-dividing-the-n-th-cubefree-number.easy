fastfunc maxprimcubefree num .
   t = 2
   while t * t <= num
      if num mod t = 0
         cnt += 1
         if cnt = 3 : num = 0
         num = num / t
      else
         cnt = 0
         t += 1
      .
   .
   if cnt = 2 and t = num : num = 0
   return num
.
i = 1
while cnt < 100
   h = maxprimcubefree i
   if h <> 0
      cnt += 1
      write h & " "
   .
   i += 1
.
print ""
nextshow = 1000
while cnt < 100000
   h = maxprimcubefree i
   if h <> 0
      cnt += 1
      if cnt = nextshow
         nextshow *= 10
         print h & " "
      .
   .
   i += 1
.
