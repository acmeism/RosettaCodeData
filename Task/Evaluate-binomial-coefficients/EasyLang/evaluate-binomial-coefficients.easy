func binomial n k .
   if k > n / 2
      k = n - k
   .
   numer = 1
   for i = n downto n - k + 1
      numer = numer * i
   .
   denom = 1
   for i = 1 to k
      denom = denom * i
   .
   return numer / denom
.
print binomial 5 3
