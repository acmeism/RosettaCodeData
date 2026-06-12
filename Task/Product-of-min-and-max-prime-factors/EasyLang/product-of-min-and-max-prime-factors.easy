proc decompose num &primes[] .
   primes[] = [ ]
   t = 2
   while t * t <= num
      if num mod t = 0
         primes[] &= t
         num = num / t
      else
         t += 1
      .
   .
   primes[] &= num
.
for i to 100
   decompose i r[]
   write r[1] * r[$] & " "
.
