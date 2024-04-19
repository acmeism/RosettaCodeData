func$ bin n .
   for i to 5
      r$ = n mod 2 & r$
      n = n div 2
   .
   return r$
.
func gray_encode b .
   return bitxor b bitshift b -1
.
func gray_decode g .
   b = g
   while g > 0
      g = bitshift g -1
      b = bitxor b g
   .
   return b
.
for n = 0 to 31
   g = gray_encode n
   b = gray_decode g
   print bin n & " -> " & bin g & " -> " & bin b
.
