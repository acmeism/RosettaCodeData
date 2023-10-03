func pow_mod b power modulus .
   x = 1
   while power > 0
      if power mod 2 = 1
         x = x * b mod modulus
      .
      b = b * b mod modulus
      power = power div 2
   .
   return x
.
numfmt 0 4
for k = 2 step 2 to 10
   print "The first 50 Curzon numbers using a base of" & k & ":"
   n = 1
   count = 0
   repeat
      m = k * n + 1
      p = pow_mod k n m + 1
      if p = m
         count += 1
         if count <= 50
            write " " & n
            if count mod 10 = 0
               print ""
            .
         .
      .
      until count = 1000
      n += 1
   .
   print "" ; print "One thousandth: " & n
   print ""
.
