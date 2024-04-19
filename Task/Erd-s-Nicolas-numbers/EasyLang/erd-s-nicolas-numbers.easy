limit = 2000000
for i to limit
   dsum[] &= 1
   dcnt[] &= 1
.
for i = 2 to limit
   j = i + i
   while j <= limit
      if dsum[j] = j
         print j & " equals the sum of its first " & dcnt[j] & " divisors"
      .
      dsum[j] += i
      dcnt[j] += 1
      j += i
   .
.
