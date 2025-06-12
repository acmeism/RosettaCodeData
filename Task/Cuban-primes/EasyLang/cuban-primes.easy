fastfunc isprim num .
   if num mod 2 = 0 : return 0
   if num mod 3 = 0 : return 0
   i = 5
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
      if num mod i = 0 : return 0
      i += 4
   .
   return 1
.
i = 1
while cnt < 50000
   di = 3 * i * (i + 1) + 1
   if isprim di = 1
      cnt += 1
      if cnt <= 200 : write di & " "
   .
   i += 1
.
print ""
print ""
print di
