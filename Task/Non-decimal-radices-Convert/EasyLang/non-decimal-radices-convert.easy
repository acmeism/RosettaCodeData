func$ num2str n base .
   if n = 0
      return "0"
   .
   d = n mod base
   if d > 9
      d += 39
   .
   d$ = strchar (d + 48)
   if n < base
      return d$
   .
   return num2str (n div base) base & d$
.
func str2num s$ base .
   r = 0
   for c$ in strchars s$
      d = strcode c$ - 48
      if d > 9
         d -= 39
      .
      r = r * base + d
   .
   return r
.
print num2str 253 16
print str2num "fd" 16
print num2str 0 16
