global cnt[] .
proc primcnt limit .
   cnt[] = [ 0 1 1 ]
   for i = 4 step 2 to limit
      cnt[] &= 0
      cnt[] &= 1
   .
   p = 3
   sq = 9
   while sq <= limit
      if cnt[p] <> 0
         for q = sq step p * 2 to limit
            cnt[q] = 0
         .
      .
      sq += (p + 1) * 4
      p += 2
   .
   for i = 2 to limit
      sum += cnt[i]
      cnt[i] = sum
   .
.
func logn n .
   return log n 0
.
func ramamax n .
   return floor (4 * n * logn (4 * n))
.
func ramaprim n .
   if n = 1 : return 2
   for i = ramamax n downto 2 * n
      if i mod 2 = 0
         if cnt[i] - cnt[i / 2] < n
            return i + 1
         .
      .
   .
   return 0
.
primcnt (1 + ramamax 1000)
print "The first 100 Ramanujan primes are:"
for i = 1 to 100
   write ramaprim i & " "
.
print ""
print ""
print "The 1000th Ramanujan prime is " & ramaprim 1000
