fastfunc nprim num .
   repeat
      i = 2
      while i <= sqrt num and num mod i <> 0
         i += 1
      .
      until num mod i <> 0
      num += 1
   .
   return num
.
prim = 2
primcnt = 1
proc nextprim .
   prim = nprim (prim + 1)
   primcnt += 1
.
for i to 20
   write prim & " "
   nextprim
.
print ""
while prim < 100
   nextprim
.
while prim <= 150
   write prim & " "
   nextprim
.
print ""
while prim < 7700
   nextprim
.
while prim <= 8000
   cnt += 1
   nextprim
.
print cnt
while primcnt < 10000
   nextprim
.
print prim
while primcnt < 100000
   nextprim
.
print prim
