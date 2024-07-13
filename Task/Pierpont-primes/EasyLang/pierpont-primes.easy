fastfunc isprim num .
   if num mod 2 = 0
      if num = 2
         return 1
      .
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
fastfunc mod2x3x n .
   while n mod 2 = 0
      n /= 2
   .
   while n mod 3 = 0
      n /= 3
   .
   return n
.
i = 2
cnt = 1
write 2 & " "
while cnt < 50
   if mod2x3x i = 1 and isprim (i + 1) = 1
      cnt += 1
      write i + 1 & " "
   .
   i += 2
.
print ""
print ""
i = 4
write 2 & " "
cnt = 1
while cnt < 50
   if mod2x3x i = 1 and isprim (i - 1) = 1
      cnt += 1
      write i - 1 & " "
   .
   i += 2
.
