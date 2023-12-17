proc prim_fact x . pf[] .
   pf[] = [ ]
   p = 2
   repeat
      if x mod p = 0
         pf[] &= p
         x = x div p
      else
         p += 1
      .
      until x = 1
   .
.
func digsum x .
   while x > 0
      sum += x mod 10
      x = x div 10
   .
   return sum
.
for i = 2 to 9999
   prim_fact i pf[]
   if len pf[] >= 2
      sum = 0
      for e in pf[]
         sum += digsum e
      .
      if digsum i = sum
         write i & " "
      .
   .
.
