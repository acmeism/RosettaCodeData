global divs[] .
proc make_divisors n .
   len divs[] 0
   for i = n div 2 downto 1
      if n mod i = 0 : divs[] &= i
   .
.
fastfunc sum_divisors n .
   term = 1
   while n > 0
      if n mod 2 = 1 : sum += divs[term]
      term += 1
      n = n div 2
   .
   return sum
.
func is_practical n .
   if n = 1 : return 1
   if n mod 2 = 1 : return 0
   if n < 5 : return 1
   len hits[] n - 1
   make_divisors n
   nt = len divs[]
   for i = 1 to pow 2 nt - 1
      sd = sum_divisors i
      if sd < n : hits[sd] += 1
   .
   for i = 1 to n - 1
      if hits[i] = 0 : return 0
   .
   return 1
.
write 1 & " "
for n = 2 to 333
   if is_practical n = 1 : write n & " "
.
print ""
