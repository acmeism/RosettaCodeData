func[] decompose num .
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
   return primes[]
.
for v in [ 27 1232125 9007199254740991 ]
   print decompose v
.
