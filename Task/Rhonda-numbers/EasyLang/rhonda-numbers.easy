fastfunc isprim n .
   i = 2
   while i <= sqrt n
      if n mod i = 0 : return 0
      i += 1
   .
   return 1
.
fastfunc digitProduct base n .
   product = 1
   while n <> 0
      product *= n mod base
      n = n div base
   .
   return product
.
fastfunc primeFactorSum n .
   for p = 2 to sqrt n
      while n mod p = 0
         sum += p
         n = n div p
      .
   .
   if n > 1 : sum += n
   return sum
.
func isRhonda base n .
   return if digitProduct base n = base * primeFactorSum n
.
for base = 2 to 16 : if isprim base = 0
   write "Base " & base & ":  "
   cnt = 0
   n = 1
   while cnt < 10
      if isRhonda base n = 1
         cnt += 1
         write n & " "
      .
      n += 1
   .
   print ""
.
