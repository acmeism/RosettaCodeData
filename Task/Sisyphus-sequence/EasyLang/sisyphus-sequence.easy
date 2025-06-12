func isprim num .
   if num mod 2 = 0 and num > 2 : return 0
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
prim = 1
proc nextprim .
   repeat
      prim += 1
      until isprim prim = 1
   .
.
numfmt 4 0
n = 1
write n
for i = 2 to 100
   if n mod 2 <> 0
      nextprim
      n += prim
   else
      n /= 2
   .
   write n
   if i mod 10 = 0 : print ""
.
