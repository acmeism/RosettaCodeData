func$ num2bin n .
   while n >= 1
      n /= 2
      f += 1
   .
   if f = 0 : b$ &= "0"
   while n > 0
      n *= 2
      if f = 0 : b$ &= "."
      f -= 1
      if n >= 1
         b$ &= "1"
         n -= 1
      else
         b$ &= "0"
      .
   .
   return b$
.
func bin2num b$ .
   f = 1
   for c$ in strchars b$
      if dot = 1 : f *= 2
      if c$ = "1"
         n = n * 2 + 1
      elif c$ = "0"
         n = n * 2 + 0
      else
         c$ = "."
         dot = 1
      .
   .
   return n / f
.
numfmt 0 6
proc show n .
   b$ = num2bin n
   print n & " => " & b$ & " => " & bin2num b$
.
show 5.625
show 2.1
