primes[] = [ ]
len sieve[][] 16000000
#
proc mkprims_facts .
   max = len sieve[][]
   for d = 2 to max : if len sieve[d][] = 0
      for i = 2 * d step d to len sieve[][]
         sieve[i][] &= d
      .
   .
   for i = 2 to len sieve[][]
      if len sieve[i][] = 0 : primes[] &= i
   .
.
mkprims_facts
#
len cats[] 16000000
#
func getcat p .
   if cats[p] <> 0 : return cats[p]
   for f in sieve[p + 1][]
      if f <> 2 and f <> 3 : break 1
   .
   if f = 0 : return 1
   for cat = 2 to 11
      f = 0
      for f in sieve[p + 1][]
         if getcat f >= cat : break 1
      .
      if f = 0
         cats[p] = cat
         return cat
      .
   .
   return 12
.
len es[][] 12
for i to 200
   c = getcat primes[i]
   es[c][] &= primes[i]
.
for c = 1 to 6
   if len es[c][] > 0
      print "Category " & c & ":"
      print es[c][]
      print ""
   .
.
print "First million primes:"
for i = 201 to 1e6
   c = getcat primes[i]
   es[c][] &= primes[i]
.
for c = 1 to 12
   l = len es[c][]
   if len es[c][] > 0
      print "Category " & c & ": First = " & es[c][1] & " Last = " & es[c][l] & " Count = " & l
   .
.
