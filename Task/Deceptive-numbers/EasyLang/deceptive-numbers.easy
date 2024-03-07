func modpow b e m .
   r = 1
   while e > 0
      if e mod 2 = 1
         r = r * b mod m
      .
      b = b * b mod m
      e = e div 2
   .
   return r
.
func is_deceptive n .
   if n mod 2 = 1 and n mod 3 <> 0 and n mod 5 <> 0
      if modpow 10 (n - 1) n = 1
         x = 7
         while x * x <= n
            if n mod x = 0 or n mod (x + 4) = 0
               return 1
            .
            x += 6
         .
      .
   .
.
while cnt < 10
   n += 1
   if is_deceptive n = 1
      write n & " "
      cnt += 1
   .
.
