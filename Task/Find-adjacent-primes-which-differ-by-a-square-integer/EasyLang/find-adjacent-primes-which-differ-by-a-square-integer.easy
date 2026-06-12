fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
prim = 2
proc nextprim .
   repeat
      prim += 1
      until isprim prim = 1
   .
.
func is_square n .
   h = floor sqrt n
   return if h * h = n
.
while prim < 1000000
   prev = prim
   nextprim
   if prim - prev > 36 and is_square (prim - prev) = 1
      print prim & " - " & prev & " = " & prim - prev
   .
.
