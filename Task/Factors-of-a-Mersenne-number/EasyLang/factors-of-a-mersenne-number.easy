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
func bit_count n .
   while n > 0
      n = bitshift n -1
      cnt += 1
   .
   return cnt
.
func mod_pow p n .
   square = 1
   bits = bit_count p
   while bits > 0
      square *= square
      bits -= 1
      if bitand p bitshift 1 bits > 0
         square = bitshift square 1
      .
      square = square mod n
   .
   return square
.
func mersenne_factor p .
   while 1 = 1
      k += 1
      q = 2 * k * p + 1
      if (q mod 8 = 1 or q mod 8 = 7) and mod_pow p q = 1 and isprim q = 1
         return q
      .
   .
.
print mersenne_factor 929
