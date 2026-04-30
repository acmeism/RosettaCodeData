func[] bnadd a[] b[] .
   if len a[] < len b[] : swap a[] b[]
   for i = 1 to len a[]
      bi = 0
      if i <= len b[] : bi = b[i]
      h = a[i] + bi + c
      r[] &= h mod 10000000
      c = h div 10000000
   .
   if c > 0 : r[] &= c
   return r[]
.
func[] bnsub a[] b[] .
   for i = 1 to len a[]
      ai = a[i]
      bi = 0
      if i <= len b[] : bi = b[i]
      bi += c
      c = 0
      if bi > ai
         ai += 10000000
         c = 1
      .
      r[] &= ai - bi
   .
   while r[$] = 0 : len r[] -1
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
proc parti n &p[][] .
   subr upd
      if k mod 2 = 1
         h[] = bnadd p[n][] p[d][]
      else
         h[] = bnsub p[n][] p[d][]
      .
      p[n][] = h[]
   .
   for k = 1 to n
      d = n - k * (3 * k - 1) div 2
      if d < 0 : break 1
      upd
      d -= k
      if d < 0 : break 1
      upd
   .
.
proc partitions_p n &p[][] .
   p[][] = [ ]
   len p[][] n + 1
   p[0][] = [ 1 ]
   for i to n : parti i p[][]
.
for nn in [ 23 123 1234 12345 ]
   partitions_p nn p[][]
   print nn & ": " & str p[nn][]
.
