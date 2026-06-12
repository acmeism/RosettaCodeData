func[] bnmul a[] b .
   for d in a[]
      h = c + d * b
      r[] &= h mod 10000000
      c = h div 10000000
   .
   if c > 0 : r[] &= c
   return r[]
.
func$ str bn[] .
   s$ = bn[$]
   for i = len bn[] - 1 downto 1
      h$ = bn[i]
      s$ &= substr "0000000" 1 (7 - len h$) & h$
   .
   return s$
.
for n = 0 to 21
   p[] = [ 1 ]
   repeat
      s$ = str p[]
      until strpos s$ n <> 0
      p[] = bnmul p[] 6
   .
   print n & " " & s$
.
