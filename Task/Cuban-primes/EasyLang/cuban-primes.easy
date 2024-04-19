fastfunc isprim_odd num .
   i = 3
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 2
   .
   return 1
.
numfmt 0 7
i = 1
while cnt < 100000
   di = 3 * i * (i + 1) + 1
   if isprim_odd di = 1
      cnt += 1
      if cnt <= 200
         write di & " "
         if cnt mod 5 = 0
            print ""
         .
      .
   .
   i += 1
.
print ""
print di
