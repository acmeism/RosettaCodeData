func[] bnmuls a[] b .
   for d in a[]
      h = d * b + c
      r[] &= h mod 10000000
      c = h div 10000000
   .
   if c > 0 : r[] &= c
   return r[]
.
func[] bnmul a[] b[] .
   len r[] len a[] + len b[]
   for ia = 1 to len a[]
      h = 0
      for ib = 1 to len b[]
         h += r[ia + ib - 1] + b[ib] * a[ia]
         r[ia + ib - 1] = h mod 10000000
         h = h div 10000000
      .
      r[ia + ib - 1] += h
   .
   while r[$] = 0 : len r[] -1
   return r[]
.
func[] bnadds a[] c .
   for i = 1 to len a[]
      h = a[i] + c
      r[] &= h mod 10000000
      c = h div 10000000
   .
   if c > 0 : r[] &= c
   return r[]
.
func[] bnsub a[] b[] .
   len r[] len a[]
   for i = 1 to len r[]
      v = 0
      if i <= len b[] : v = b[i]
      h = a[i] - v - c
      c = 0
      if h < 0
         h += 10000000
         c = 1
      .
      r[i] = h
   .
   while len r[] > 1 and r[$] = 0 : len r[] -1
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
func[] bn s$ .
   i = len s$ - 7 + 1
   while i >= -5
      r[] &= number substr s$ i 7
      i -= 7
   .
   return r[]
.
func cmp a[] b[] .
   if len a[] > len b[] : return 1
   if len a[] < len b[] : return -1
   for i = len a[] downto 1
      if a[i] > b[i] : return 1
      if a[i] < b[i] : return -1
   .
   return 0
.
numb = 2
i[] = [ numb ]
d = floor sqrt numb
j[] = [ d ]
k[] = [ d ]
n = 500
n0 = n
repeat
   write d
   i[] = bnmuls bnsub i[] bnmuls k[] d 100
   k[] = bnmuls j[] 20
   d = 1
   while d <= 10
      h[] = bnmuls bnadds k[] d d
      if cmp h[] i[] = 1
         d -= 1
         break 1
      .
      d += 1
   .
   j[] = bnadds bnmuls j[] 10 d
   k[] = bnadds k[] d
   if n0 > 0 : n -= 1
   until n = 0
.
print ""
