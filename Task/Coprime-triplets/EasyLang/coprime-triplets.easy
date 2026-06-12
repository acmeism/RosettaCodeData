func gcd a b .
   while b <> 0
      h = b
      b = a mod b
      a = h
   .
   return a
.
max = 49
len isin[] max
n = 3
pp = 1
p = 2
write "1 2 "
while n <= max
   if gcd n p = 1 and gcd n pp = 1 and isin[n] = 0
      write n & " "
      isin[n] = 1
      pp = p
      p = n
      n = 3
   else
      n += 1
   .
.
