n = 1e7
len sieve[] n
fastproc mksieve .
   max = sqrt len sieve[]
   for i = 2 to max : if sieve[i] = 0
      j = i * i
      while j <= len sieve[]
         sieve[j] = 1
         j += i
      .
   .
.
mksieve
for n = 3 step 2 to n
   if sieve[n] = 0 and sieve[n + 2] = 0
      if sqrt (n + n + 2) mod 1 = 0
         write "(" & n & " " & n + 2 & ") "
      .
   .
.
print ""
