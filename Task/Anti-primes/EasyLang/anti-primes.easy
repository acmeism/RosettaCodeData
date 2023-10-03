func divcnt v .
   n = v
   tot = 1
   p = 2
   while p <= sqrt n
      cnt = 1
      while n mod p = 0
         cnt += 1
         n = n div p
      .
      p += 1
      tot *= cnt
   .
   if n > 1
      tot *= 2
   .
   return tot
.
while count < 20
   n += 1
   divs = divcnt n
   if divs > max
      print n
      max = divs
      count += 1
   .
.
