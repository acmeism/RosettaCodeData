func$ tobin k .
   if k > 0
      return tobin (k div 2) & k mod 2
   .
.
p = 2
repeat
   n += 1
   if n >= p
      p += p
   .
   k = n + n * p
   until k >= 1000
   print k & ": " & tobin k
.
