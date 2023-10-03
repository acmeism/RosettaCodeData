fastfunc next n .
   while 1 = 1
      n += 1
      h = n
      nrev = 0
      while h > 0
         nrev = nrev * 10 + h mod 10
         h = h div 10
      .
      if sqrt (n + nrev) mod 1 = 0
         if n - nrev >= 1 and sqrt (n - nrev) mod 1 = 0
            return n
         .
      .
   .
.
for cnt to 5
   n = next n
   print n
.
