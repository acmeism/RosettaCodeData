fastfunc isprimodd n .
   i = 3
   while i <= sqrt n
      if n mod i = 0 : return 0
      i += 2
   .
   return 1
.
limit = 100000
primes[] = [ 2 ]
for n = 5 step 2 to limit
   if isprimodd n = 1 : primes[] &= n
.
twins[] = [ 3 ]
for i = 1 to len primes[] - 1
   if primes[i + 1] - primes[i] = 2
      if twins[$] <> primes[i] : twins[] &= primes[i]
      twins[] &= primes[i + 1]
   .
.
proc nonTwinSums twins[] .
   len sieve[] limit + 1
   for i = 1 to len twins[]
      for j = i to len twins[]
         sum = twins[i] + twins[j]
         if sum > limit : break 1
         sieve[sum] = 1
      .
   .
   i = 2
   while i <= limit
      if sieve[i] = 0 : write i & " "
      i += 2
   .
   print ""
.
nonTwinSums twins[]
print ""
twins1[] = [ 1 ]
for v in twins[] : twins1[] &= v
nonTwinSums twins1[]
