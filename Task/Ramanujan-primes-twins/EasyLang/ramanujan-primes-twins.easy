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
func log n .
   e = 2.7182818284590452354
   return log10 n / log10 e
.
func ramamax n .
   return floor (4 * n * log (4 * n))
.
func ramaprim_twins n .
   i = ramamax n
   i -= i mod 2
   while i >= 2
      if cnt[i] - cnt[i / 2] < n
         p1 = p
         p = i + 1
         if p1 - p = 2
            cnt += 1
         .
         n -= 1
      .
      i -= 2
   .
   return cnt
.
primcnt ramamax 1000000
print ramaprim_twins 1000000
