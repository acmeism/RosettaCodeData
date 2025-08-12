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
   while r[$] = 0
      len r[] -1
   .
   return r[]
.
func[] bnadd a[] b[] .
   if len a[] < len b[] : swap a[] b[]
   for i = 1 to len b[]
      h = a[i] + b[i] + c
      r[] &= h mod 10000000
      c = h div 10000000
   .
   for i = len b[] + 1 to len a[]
      h = a[i] + c
      r[] &= h mod 10000000
      c = h div 10000000
   .
   if c > 0 : r[] &= c
   return r[]
.
func[] bndiv10x a[] d .
   len r[] len a[]
   x = 10000000 div d
   for i = len a[] downto 1
      r[i] = a[i] div d + m * x
      m = a[i] mod d
   .
   if r[$] = 0 : len r[] -1
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
func[] mkcur dollar cent .
   return [ 100 * dollar + cent ]
.
func[] mkcurs s$ .
   n[] = number strsplit s$ "."
   return [ 100 * n[1] + n[2] ]
.
func[] gettax a[] num denom .
   return bndiv10x bnadd bnmul a[] [ num ] [ denom div 2 ] denom
.
func$ curstr cur[] .
   s$ = str cur[]
   h = len s$
   return substr s$ 1 (h - 2) & "." & substr s$ (h - 1) 2
.
#
hamburger[] = bnmul mkcur 5 50 bn "4000000000000000"
milkshakes[] = bnmul mkcurs "2.86" [ 2 ]
before_tax[] = bnadd hamburger[] milkshakes[]
print curstr before_tax[]
tax[] = gettax before_tax[] 765 10000
print curstr tax[]
total[] = bnadd before_tax[] tax[]
print curstr total[]
