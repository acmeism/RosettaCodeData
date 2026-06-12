fastfunc powmod a b m .
   r = 1
   while b >= 1
      if b mod 2 = 1
         r = r * a mod m
      .
      b = b div 2
      a = a * a mod m
   .
   return r
.
fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
func[] divisors n .
   d = 2
   while d * d <= n
      if n mod d = 0
         r[] &= d
         q = n div d
         if q <> d
            r[] &= q
         .
      .
      d += 1
   .
   return r[]
.
func is_super_poulet n .
   if isprim n = 1 or powmod 2 (n - 1) n <> 1
      return 0
   .
   for d in divisors n
      if powmod 2 d d <> 2
         return 0
      .
   .
   return 1
.
n = 3
while 1 = 1
   if is_super_poulet n = 1
      cnt += 1
      if cnt <= 20
         write n & " "
      .
      if n > 1e6
         break 1
      .
   .
   n += 2
.
print ""
print ""
print cnt & " " & n
