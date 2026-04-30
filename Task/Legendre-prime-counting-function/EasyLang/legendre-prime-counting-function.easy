global primes[] .
proc mkprimes n .
   len sieve[] n
   max = sqrt n
   for d = 2 to max : if sieve[d] = 0
      for i = d * d step d to n
         sieve[i] = 1
      .
   .
   primes[] = [ ]
   for i = 2 to n
      if sieve[i] = 0 : primes[] &= i
   .
.
fastfunc phi x a .
   while a > 1
      pa = primes[a]
      if x <= pa : return 1
      sum += phi (x div pa) (a - 1)
      a -= 1
   .
   return x - (x div 2) - sum
.
func pix n .
   if n < 2 : return 0
   if n = 2 : return 1
   mkprimes floor sqrt n
   a = len primes[]
   return phi n a + a - 1
.
for i = 0 to 9
   n = pow 10 i
   print "10^" & i & "  " & pix n
.
