fastfunc isprim num .
   if num mod 2 = 0 and num > 2 : return 0
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
func[] divisors n .
   for d = 2 to n - 1
      if n mod d = 0 : r[] &= d
   .
   return r[]
.
func iscalmo n .
   d[] = divisors n
   if len d[] = 0 or len d[] mod 3 <> 0 : return 0
   for i = 1 step 3 to len d[] - 2
      if isprim (d[i] + d[i + 1] + d[i + 2]) = 0 : return 0
   .
   return 1
.
for n to 1000
   if iscalmo n = 1 : write n & " "
.
print ""
