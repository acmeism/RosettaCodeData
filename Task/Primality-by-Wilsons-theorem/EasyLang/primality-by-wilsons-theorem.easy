func wilson_prime n .
   fct = 1
   for i = 2 to n - 1
      fct = fct * i mod n
   .
   return if fct = n - 1
.
for i = 2 to 100
   if wilson_prime i = 1
      write i & " "
   .
.
