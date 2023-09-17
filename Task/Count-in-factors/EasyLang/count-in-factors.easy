proc decompose num . primes[] .
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
for i = 1 to 30
   write i & ": "
   decompose i primes[]
   for j = 1 to len primes[]
      if j > 1
         write " x "
      .
      write primes[j]
   .
   print ""
   primes[] = [ ]
.
