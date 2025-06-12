len nfac[] 1000000
proc sieve .
   nfac[1] = 1
   for i = 2 to len nfac[]
      if nfac[i] = 0
         j = i + i
         while j <= len nfac[]
            if j div i mod i = 0 : nfac[j] = 5
            nfac[j] += 1
            j += i
         .
      .
   .
.
sieve
#
fastfunc isprim num .
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
fastfunc nextprim prim .
   if prim = 2 : return 3
   repeat
      prim += 2
      until isprim prim = 1
   .
   return prim
.
proc sort &d[] .
   for i = 1 to len d[] - 1 : for j = i + 1 to len d[]
      if d[j] < d[i] : swap d[j] d[i]
   .
.
proc calc max dir .
   h$ = " preceeded"
   if dir = 1 : h$ = " followed"
   print "Primes below " & max & h$ & " by a tetraprime pair:"
   if max <= 100000 : print ""
   prim = 7
   while prim < max
      if nfac[prim + dir] = 4 and nfac[prim + dir + dir] = 4
         if (prim + dir) mod 7 = 0 or (prim + dir + dir) mod 7 = 0 : cnt += 1
         if prev > 0 : d[] &= prim - prev
         prev = prim
         if max <= 100000 : write prim & " "
      .
      prim = nextprim prim
   .
   if max <= 100000 : print ""
   print ""
   print len d[] + 1 & " " & cnt
   print ""
   sort d[]
   print d[1] & " " & d[$ div 2 + 1] & " " & d[$]
   print ""
.
calc 100000 -1
calc 100000 1
calc 1000000 -1
calc 1000000 1
