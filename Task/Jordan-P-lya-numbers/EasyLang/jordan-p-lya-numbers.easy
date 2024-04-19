fastfunc jpnum m .
   n = m
   limite = 7
   while 1 = 1
      fac = 1
      i = 1
      while i < limite
         i += 1
         fac *= i
      .
      repeat
         q = n div fac
         if n mod fac = 0
            if q = 1
               return 1
            .
            n = q
         else
            fac = fac / i
            i -= 1
         .
         until i = 1
      .
      limite -= 1
      if limite = 0
         return 0
      .
      n = m
   .
.
numfmt 0 5
write 1
c = 1
n = 2
repeat
   if jpnum n = 1
      c += 1
      if c <= 50
         write n
         if c mod 8 = 0
            print ""
         .
      .
      sn = n
   .
   n += 2
   until n >= 1e8
.
print ""
print "The largest Jordan-Polya number before 100 million: " & sn
