alpha$ = "0123456789AB"
func$ itoa n b .
   if n > 0
      return itoa (n div b) b & substr alpha$ (n mod b + 1) 1
   .
.
func unique s$ .
   len dig[] 12
   for c$ in strchars s$
      ind = strpos alpha$ c$
      dig[ind] = 1
   .
   for v in dig[]
      cnt += v
   .
   return cnt
.
proc find b . .
   n = floor pow b ((b - 1) div 2)
   repeat
      sq = n * n
      sq$ = itoa sq b
      until len sq$ >= b and unique sq$ = b
      n += 1
   .
   n$ = itoa n b
   print "Base " & b & ": " & n$ & "² = " & sq$
.
for base = 2 to 12
   find base
.
