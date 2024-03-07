write "Mersenne Primes: "
func lulehm p .
   mp = bitshift 1 p - 1
   sn = 4
   for i = 2 to p - 1
      sn = sn * sn - 2
      sn = sn - (mp * (sn div mp))
   .
   return if sn = 0
.
for p = 2 to 23
   if lulehm p = 1
      write "M" & p & " "
   .
.
