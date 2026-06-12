fastfunc sigsum n .
   for i = 1 to sqrt n
      if n mod i = 0
         sumdiv += i
         if i <> n div i : sumdiv += n div i
      .
   .
   return sumdiv
.
fastfunc next num .
   repeat
      num += 1
      until sigsum num = sigsum (num + 1)
   .
   return num
.
while cnt < 50
   num = next num
   cnt += 1
   write num & " "
.
print ""
