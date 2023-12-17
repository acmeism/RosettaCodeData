func isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
func is_wilson n p .
   if p < n
      return 0
   .
   prod = 1
   p2 = p * p
   for i = 1 to n - 1
      prod = prod * i mod p2
   .
   for i = 1 to p - n
      prod = prod * i mod p2
   .
   prod = (p2 + prod - pow -1 n) mod p2
   if prod = 0
      return 1
   .
   return 0
.
print "n:  Wilson primes"
print "-----------------"
for n = 1 to 11
   write n & "   "
   for p = 3 step 2 to 10099
      if isprim p = 1 and is_wilson n p = 1
         write p & " "
      .
   .
   print ""
.
