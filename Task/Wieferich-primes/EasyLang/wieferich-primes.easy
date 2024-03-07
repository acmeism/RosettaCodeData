fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
func weiferich p .
   if isprim p = 0
      return 0
   .
   q = 1
   p2 = p * p
   while p > 1
      q = (2 * q) mod p2
      p -= 1
   .
   if q = 1
      return 1
   .
.
print "Wieferich primes less than 5000: "
for i = 2 to 5000
   if weiferich i = 1
      print i
   .
.
