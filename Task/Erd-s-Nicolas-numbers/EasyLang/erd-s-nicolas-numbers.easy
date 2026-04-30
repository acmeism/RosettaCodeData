limit = 2000000
global r[] .
fastproc .
   for i to limit
      dsum[] &= 1
      dcnt[] &= 1
   .
   for i = 2 to limit
      j = i + i
      while j <= limit
         if dsum[j] = j
            r[] &= j
            r[] &= dcnt[j]
         .
         dsum[j] += i
         dcnt[j] += 1
         j += i
      .
   .
.
for i = 1 step 2 to len r[]
   print r[i] & " equals the sum of its first " & r[i + 1] & " divisors"
.
